#!/usr/bin/env ruby

require "date"
require "json"
require "pathname"
require "yaml"

build_dir = Pathname(ARGV.fetch(0)).realpath
repo_dir = Pathname(ARGV.fetch(1)).realpath
errors = []
daily_haiku_item = nil
poster_data = YAML.safe_load(
  repo_dir.join("data/posters.yaml").read,
  permitted_classes: [Date],
  aliases: true
) || []
expected_stop1_editions = poster_data.length

check = lambda do |condition, message|
  errors << message unless condition
end

json_files = {
  "ai-index.json" => %w[schemaVersion owner sections itemCount items],
  "ai-content.json" => %w[schemaVersion owner contentFormat itemCount items],
  "ai-nav.json" => %w[schemaVersion primary sections],
  "ai-readme.json" => %w[schemaVersion identity site_structure data_endpoints],
  "updates.json" => %w[schemaVersion updates statistics],
  "index.json" => %w[schemaVersion owner itemCount items]
}

parsed_json = {}
json_files.each do |filename, required_keys|
  path = build_dir.join(filename)
  check.call(path.file?, "Missing generated endpoint: /#{filename}")
  next unless path.file?

  begin
    parsed_json[filename] = JSON.parse(path.read)
    missing = required_keys - parsed_json[filename].keys
    check.call(missing.empty?, "/#{filename} is missing keys: #{missing.join(', ')}")
  rescue JSON::ParserError => e
    errors << "Invalid JSON in /#{filename}: #{e.message}"
  end
end

index = parsed_json["ai-index.json"]
content = parsed_json["ai-content.json"]
if index && content
  check.call(index["itemCount"] == index["items"].length, "/ai-index.json itemCount does not match items")
  check.call(content["itemCount"] == content["items"].length, "/ai-content.json itemCount does not match items")
  check.call(index["itemCount"] == content["itemCount"], "AI index/content item counts differ")
  check.call(content["items"].all? { |item| item.key?("content") }, "/ai-content.json contains summary-only items")

  writing = content["items"].select { |item| item["section"] == "writing" && item["kind"] == "page" }
  empty_writing = writing.select { |item| item["content"].to_s.strip.empty? }.map { |item| item["url"] }
  check.call(empty_writing.empty?, "Published writing has empty full-text content: #{empty_writing.join(', ')}")

  daily_haiku_item = writing.find { |item| item["url"].end_with?("/writing/daily-haikus/") }
  check.call(!daily_haiku_item.nil?, "Daily Haiku is missing from /ai-content.json")

  modification_counts = index["items"].group_by { |item| item["lastModified"] }.transform_values(&:length)
  check.call(modification_counts.length > 10, "Modification dates collapsed to #{modification_counts.length} distinct values; deployment may be using shallow Git history")

  music = content["items"].find { |item| item["url"].end_with?("/music/") }
  soundcloud = music && music["soundcloud"]
  check.call(soundcloud.is_a?(Hash), "Music is missing structured SoundCloud metadata")
  if soundcloud.is_a?(Hash)
    %w[artist_url mixes_url tracks_url mixes_playlist_id tracks_playlist_id].each do |key|
      check.call(!soundcloud[key].to_s.empty?, "Music SoundCloud metadata is missing #{key}")
    end
  end

  gallery = index["items"].find { |item| item["url"].end_with?("/portraits/alyssa/") }
  check.call(gallery && gallery["imageCount"].to_i.positive?, "Compact AI index is missing gallery image counts")
  check.call(gallery && !gallery["coverImage"].to_s.empty?, "Compact AI index is missing gallery cover images")

  event_editions = index["items"].select { |item| item["eventSeries"] == "stop1" }
  check.call(event_editions.length == expected_stop1_editions, "AI index contains #{event_editions.length} stop1 editions instead of #{expected_stop1_editions}")
  check.call(
    event_editions.all? do |item|
      !item["posterAlt"].to_s.empty? &&
        (!item["coverImageCloudflareId"].to_s.empty? || !item["coverImage"].to_s.empty?)
    end,
    "AI index is missing stop1 poster metadata"
  )
end

html_files = build_dir.glob("**/*.html")
html_files.each do |path|
  html = path.read
  html.scan(/<script[^>]+type=(?:["'])?application\/ld\+json(?:["'])?[^>]*>(.*?)<\/script>/mi).each_with_index do |match, index_number|
    begin
      JSON.parse(match.first)
    rescue JSON::ParserError => e
      errors << "Invalid JSON-LD in #{path.relative_path_from(build_dir)} (script #{index_number + 1}): #{e.message}"
    end
  end
  check.call(!html.include?("livereload.js"), "Development livereload script leaked into #{path.relative_path_from(build_dir)}")
end

now_html = build_dir.join("now/index.html").read
check.call(now_html.include?("What I&rsquo;m focused on right now"), "/now/ did not render its page content")
check.call(!now_html.include?("No content found"), "/now/ fell through to the empty list template")

music_html = build_dir.join("music/index.html").read
check.call(music_html.include?("https://soundcloud.com/kettle9999/sets/mixes"), "Music HTML is missing a crawlable mixes URL")
check.call(music_html.include?("https://soundcloud.com/kettle9999/sets/tracks"), "Music HTML is missing a crawlable tracks URL")
check.call(!music_html.include?("103ecd23-4e63-4f5b-f35c-a8a748bdc200"), "Music still contains the stop1 poster archive")

sitemap_dates = build_dir.join("sitemap.xml").read.scan(/<lastmod>([^<]+)/).flatten
check.call(sitemap_dates.uniq.length > 10, "Sitemap modification dates collapsed to #{sitemap_dates.uniq.length} distinct values")

updates = parsed_json["updates.json"]
if updates
  update_dates = updates["updates"].map { |item| item["lastModified"] }
  check.call(update_dates == update_dates.sort.reverse, "/updates.json is not sorted by modification date")
  recent_titles = updates["updates"].first(10).map { |item| item["title"].to_s.strip }
  check.call(recent_titles.include?("Daily Haiku"), "Daily Haiku is missing from the latest updates")
  check.call(recent_titles.include?("Music"), "Updated Music section is missing from the latest updates")
end

home_html = build_dir.join("index.html").read
check.call(home_html.include?("id=haiku-section") || home_html.include?("id=\"haiku-section\""), "Homepage haiku did not render")
haiku_lines = home_html.scan(/class=(?:["'])?haiku-line(?:["'])?[^>]*>/).length
check.call(haiku_lines == 3, "Homepage haiku rendered #{haiku_lines} lines instead of 3")
featured_event_links = home_html.scan(%r{href=(?:["'])?/events/stop1/\d{4}-\d{2}-\d{2}/}).uniq
check.call(featured_event_links.length == 3, "Homepage rendered #{featured_event_links.length} linked stop1 posters instead of 3")
%w[Bassiani Why\ I\ Water\ My\ Plant This\ Trail\ Will\ End].each do |title|
  check.call(home_html.include?(title), "Homepage selected writing is missing #{title}")
end

events_html = build_dir.join("events/index.html").read
check.call(events_html.include?("/events/stop1/"), "Events landing page is missing stop1")
stop1_html = build_dir.join("events/stop1/index.html").read
stop1_links = stop1_html.scan(%r{href=(?:["'])?/events/stop1/\d{4}-\d{2}-\d{2}/}).uniq
check.call(stop1_links.length == expected_stop1_editions, "stop1 archive rendered #{stop1_links.length} linked editions instead of #{expected_stop1_editions}")

poster_data.each do |poster|
  next if poster["image"].to_s.empty?
  image_path = repo_dir.join("static", poster["image"].delete_prefix("/"))
  check.call(image_path.file?, "Missing local stop1 poster: #{poster['image']}")
end

navigation = parsed_json["ai-nav.json"]
if navigation
  primary_names = navigation["primary"].map { |item| item["name"] }
  check.call(primary_names.include?("Events"), "AI navigation is missing Events")
end

broken_links = []
html_files.each do |path|
  path.read.scan(/\b(?:href|src)=(?:"([^"]+)"|'([^']+)'|([^\s>]+))/i).each do |captures|
    value = captures.compact.first
    next if value.nil? || value.empty?
    next if value.start_with?("http:", "https:", "mailto:", "data:", "#", "//")

    clean = value.split(/[?#]/, 2).first
    next if clean.nil? || clean.empty?

    target = if clean.start_with?("/")
      build_dir.join(clean.delete_prefix("/"))
    else
      path.dirname.join(clean).cleanpath
    end
    candidates = [target, target.join("index.html")]
    broken_links << "#{path.relative_path_from(build_dir)} -> #{value}" unless candidates.any?(&:file?)
  end
end
check.call(broken_links.empty?, "Broken internal references:\n  #{broken_links.uniq.join("\n  ")}")

uuid = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
front_matter = lambda do |path|
  raw = path.read
  match = raw.match(/\A(?:\uFEFF)?[ \t\r\n]*---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\z)/m)
  next {} unless match
  YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
rescue Psych::SyntaxError => e
  errors << "Invalid front matter in #{path.relative_path_from(repo_dir)}: #{e.message}"
  {}
end

repo_dir.glob("content/**/*.md").each do |path|
  metadata = front_matter.call(path)
  next if metadata["draft"] == true
  check.call(metadata.key?("date") || metadata.key?("lastmod"), "Published content has no deployment-stable date source: #{path.relative_path_from(repo_dir)}")
end

daily_metadata = front_matter.call(repo_dir.join("content/writing/daily haikus.md"))
expected_daily_lastmod = daily_metadata["lastmod"].to_s
if daily_haiku_item
  check.call(
    daily_haiku_item["lastModified"] == expected_daily_lastmod,
    "Daily Haiku lastModified is #{daily_haiku_item["lastModified"].inspect}; expected front matter #{expected_daily_lastmod.inspect}"
  )
end

repo_dir.glob("content/photos/*.md").each do |path|
  metadata = front_matter.call(path)
  next if metadata["draft"] == true
  check.call(!metadata["alt"].to_s.strip.empty?, "Missing alt text: #{path.relative_path_from(repo_dir)}")
  check.call(uuid.match?(metadata["cloudflare_id"].to_s), "Invalid Cloudflare image ID: #{path.relative_path_from(repo_dir)}")
end

repo_dir.glob("content/{portraits,parties,places}/*/index.md").each do |path|
  metadata = front_matter.call(path)
  next if metadata["draft"] == true

  arrays = %w[series_images series_cloudflare_ids series_alt_texts].to_h do |key|
    [key, Array(metadata[key])]
  end
  lengths = arrays.transform_values(&:length)
  check.call(lengths.values.uniq.length == 1 && lengths.values.first.to_i.positive?, "Gallery arrays do not align in #{path.relative_path_from(repo_dir)}: #{lengths}")
  check.call(arrays["series_alt_texts"].all? { |alt| !alt.to_s.strip.empty? }, "Blank gallery alt text: #{path.relative_path_from(repo_dir)}")
  check.call(arrays["series_cloudflare_ids"].all? { |id| uuid.match?(id.to_s) }, "Invalid gallery Cloudflare image ID: #{path.relative_path_from(repo_dir)}")
end

expected_layouts = %w[index.aiindex.json index.aicontent.json index.ainav.json index.aireadme.json index.aisitemap.txt]
expected_layouts.each do |filename|
  check.call(repo_dir.join("layouts", filename).file?, "Missing Hugo output-format layout: layouts/#{filename}")
end

if errors.any?
  warn "Site validation failed:\n\n- #{errors.join("\n- ")}"
  exit 1
end

puts "Validated #{html_files.length} HTML pages, #{json_files.length} JSON endpoints, and all published photo metadata."
