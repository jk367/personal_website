#!/usr/bin/env python3
"""Refresh checked-in responsive images and dimensions. Requires Pillow and Ruby.

Run after adding/changing image metadata, never during deployment. Downloads are
cached outside the repository; Hugo builds remain offline and reproducible.
"""
import argparse
import concurrent.futures
import hashlib
import io
import json
from pathlib import Path
import subprocess
import tempfile
from urllib.parse import urlparse

from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[1]
RUBY_METADATA = r'''
require "yaml"; require "json"; require "date"
pages = Dir["content/**/*.md"].map do |path|
  match = File.read(path).match(/\A\s*---\s*\n(.*?)\n---/m)
  next unless match
  data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true)
  next if data["draft"]
  data
end.compact
site = YAML.safe_load(File.read("data/site.yaml"))
puts JSON.generate({pages: pages, account: site["brand"]["cloudflare_images_account"]})
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--refresh", action="store_true", help="Download sources again")
    args = parser.parse_args()
    metadata = json.loads(subprocess.check_output(["ruby", "-e", RUBY_METADATA], cwd=ROOT))
    account = metadata["account"]
    cloudflare = lambda image_id, variant="full": f"https://imagedelivery.net/{account}/{image_id}/{variant}"
    sources = set()
    for page in metadata["pages"]:
        if page.get("cloudflare_id"):
            sources.add(cloudflare(page["cloudflare_id"]))
        sources.update(cloudflare(image_id) for image_id in page.get("series_cloudflare_ids", []))
        if page.get("event_series"):
            if page.get("cover_image_cloudflare_id"):
                sources.add(cloudflare(page["cover_image_cloudflare_id"]))
            elif page.get("poster_image"):
                sources.add(page["poster_image"])
        elif page.get("cover_image_cloudflare_id"):
            # Keep the existing CDN cover composition, including its crop.
            sources.add(cloudflare(page["cover_image_cloudflare_id"], "griddisplay"))
        elif page.get("cover_image"):
            sources.add(page["cover_image"])
    cache = Path(tempfile.gettempdir()) / "jmkettle-image-sources"
    cache.mkdir(exist_ok=True)
    output = ROOT / "static/images/optimized"
    output.mkdir(parents=True, exist_ok=True)

    def prepare(source):
        if source.startswith("/"):
            raw = (ROOT / "static" / source.lstrip("/")).read_bytes()
        else:
            if urlparse(source).hostname not in {"imagedelivery.net", "photos.jmkettle.com", "jmkettle.com"}:
                raise ValueError(f"Unexpected image host: {source}")
            cached = cache / hashlib.sha256(source.encode()).hexdigest()
            if args.refresh or not cached.exists():
                raw = subprocess.check_output([
                    "curl", "--fail", "--location", "--silent", "--show-error",
                    "--retry", "2", "--max-time", "45", "-H", "Accept: image/webp,image/*;q=0.8", source,
                ])
                # Validate before caching, so an HTML error cannot poison later runs.
                Image.open(io.BytesIO(raw)).verify()
                cached.write_bytes(raw)
            raw = cached.read_bytes()
        photo = ImageOps.exif_transpose(Image.open(io.BytesIO(raw)))
        photo.load()
        width, height = photo.size
        variants = []
        for target in sorted({min(width, 480), min(width, 800)}):
            resized = photo.resize((target, round(height * target / width)), Image.Resampling.LANCZOS)
            encoded = io.BytesIO()
            resized.save(encoded, "WEBP", quality=90, method=6)
            payload = encoded.getvalue()
            filename = f"{hashlib.sha256(payload).hexdigest()[:20]}-{target}.webp"
            (output / filename).write_bytes(payload)
            variants.append({"url": f"/images/optimized/{filename}", "width": target, "height": resized.height})
        return source, {"width": width, "height": height, "variants": variants}

    results = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        for source, entry in pool.map(prepare, sorted(sources)):
            results[source] = entry
    manifest = ROOT / "data/image_delivery.json"
    manifest.write_text(json.dumps(results, indent=2, sort_keys=True) + "\n")
    print(f"Prepared {len(results)} image sources; manifest: {manifest.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
