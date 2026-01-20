# CLAUDE.md - AI Assistant Guide for jmkettle.com

This document provides comprehensive guidance for AI assistants working with the jmkettle.com personal website codebase.

## Project Overview

**jmkettle.com** is a personal portfolio website showcasing:
- Photography (individual photos, portrait series, party documentation, travel photography)
- Writing (essays, poetry, haikus)
- Music (tracks, mixes, productions with SoundCloud integration)
- Projects (Stop1 party series, everyrecordstore, etc.)

The site is built with Hugo static site generator and features a unique AI-first architecture with custom JSON endpoints designed specifically for AI assistants.

**Live URL:** https://jmkettle.com/

---

## Technology Stack

### Core Technologies
- **Hugo** - Static site generator (v4+)
- **TOML** - Configuration format
- **Cloudflare Images** - Primary image CDN and delivery
- **Vanilla JavaScript** - Minimal client-side functionality
- **Custom CSS** - Inline styles, no frameworks

### External Services
- **Cloudflare Pages/Netlify** - Hosting and deployment
- **SoundCloud** - Music embeds with lazy loading
- **Cloudflare CDN** - Image delivery at `imagedelivery.net`
- **Photos subdomain** - Fallback at `https://photos.jmkettle.com/`

### Special Features
- Custom Hugo output formats (AIIndex, AIContent, AINav)
- Responsive image delivery with `<picture>` elements
- Schema.org structured data
- Daily haiku rotation system
- Random photo selection on homepage

---

## Directory Structure

```
/
├── content/           # All markdown content
│   ├── writing/       # Essays and poetry (*.md files)
│   ├── photos/        # Individual portfolio photos (*.md files)
│   ├── portraits/     # Portrait series (page bundles with index.md)
│   ├── parties/       # Event photography series (page bundles)
│   ├── places/        # Travel photography (berlin-2024, georgia, etc.)
│   ├── projects/      # Project pages (stop1, music, everyrecordstore)
│   ├── music/         # Music tracks and mixes
│   ├── about.md       # Biography page
│   └── _index.md      # Homepage content
│
├── layouts/           # Hugo templates
│   ├── _default/      # Base templates (baseof.html, single.html, list.html)
│   ├── index.html     # Homepage (complex logic for haikus & random photos)
│   ├── photos/        # Photo section templates
│   ├── writing/       # Writing section templates
│   ├── music/         # Music section templates
│   ├── portraits/     # Portrait series templates
│   ├── parties/       # Party series templates
│   ├── places/        # Travel photography templates
│   ├── projects/      # Project templates
│   ├── about/         # About page template
│   └── shortcodes/    # Reusable components (poster-grid.html)
│
├── data/              # Structured data
│   └── photos.yaml    # Centralized photo metadata (Cloudflare IDs, titles, dates, alt text)
│
├── static/            # Static assets
│   ├── _headers       # Security headers and cache control
│   ├── robots.txt     # SEO and AI crawler configuration
│   ├── ai-readme.json # AI assistant documentation
│   ├── ai-sitemap.txt # AI-specific sitemap
│   ├── updates.json   # Changelog endpoint
│   └── favicon.png    # Site icon
│
├── public/            # Generated site (do not edit directly)
├── archetypes/        # Content templates for new posts
├── backup/            # Backups of portraits, parties, places
├── config.toml        # Main Hugo configuration
└── fix-typos.sh       # Automated typo correction script
```

---

## Content Management

### Content Types

#### 1. Individual Photos (`content/photos/*.md`)
Single markdown files for portfolio photos.

**Front Matter Pattern:**
```yaml
---
title: "Essex Street"
cloudflare_id: "e03d50d9-305b-467b-e186-16b2d6dd5a00"
date: 2024-09-03
image: "https://photos.jmkettle.com/essex_street.webp"
alt: "Plastic film flying in subway"
categories: []
draft: false
---
```

**Key Fields:**
- `cloudflare_id` - UUID for Cloudflare Images CDN
- `image` - Fallback URL at photos.jmkettle.com
- `alt` - Accessibility description (REQUIRED)
- `draft` - Set to `true` to hide from production

#### 2. Photo Series (`content/portraits/*/index.md`, `content/parties/*/index.md`, etc.)
Page bundles with multiple images.

**Front Matter Pattern:**
```yaml
---
title: "Alyssa"
date: 2024-11-20
draft: false
layout: "photo-series"
cover_image: "https://photos.jmkettle.com/portraits/alyssa/01.webp"
series_images:
  - "https://photos.jmkettle.com/portraits/alyssa/01.webp"
  - "https://photos.jmkettle.com/portraits/alyssa/02.webp"
series_cloudflare_ids:
  - "e8dc66ba-7a49-4d97-dc33-e8e742b44200"
  - "b85a0b21-b80d-4e08-c411-2fec697a9c00"
series_alt_texts:
  - "portrait of alyssa"
  - "portrait of alyssa"
---
```

**Key Fields:**
- `layout: "photo-series"` - Uses specialized template
- `series_images` - Array of fallback URLs
- `series_cloudflare_ids` - Array of Cloudflare UUIDs
- `series_alt_texts` - Array of descriptions (MUST match length of images)

#### 3. Writing - Essays & Poetry (`content/writing/*.md`)

**Front Matter Pattern:**
```yaml
---
title: "Contra AirPods"
date: 2025-09-16T11:23:36+02:00
writing_categories: ["essay"]
draft: false
---

Content starts here...
```

**Writing Categories:**
- `essay` - Long-form essays
- `poetry` - Poetry
- `haiku` - Haikus (special parsing on homepage)

#### 4. Music (`content/music/*.md`)

**Front Matter Pattern:**
```yaml
---
title: "Track Name"
date: 2024-01-15
soundcloud_url: "https://soundcloud.com/..."
type: "track"
genres: ["house", "techno"]
music_categories: ["mixes", "productions"]
draft: false
---
```

**Music Categories:**
- `mixes` - DJ mixes
- `productions` - Original productions

---

## Photo Management System

### Dual Photo Storage
1. **Cloudflare Images** (Primary)
   - Automatic optimization and resizing
   - Variants: `gridthumb`, `griddisplay`, `full`
   - Format: `https://imagedelivery.net/<account>/<cloudflare_id>/<variant>`

2. **Direct URLs** (Fallback)
   - Format: `https://photos.jmkettle.com/<filename>.webp`
   - Used when Cloudflare unavailable

### Photo Metadata Database
All photos are cataloged in `/data/photos.yaml`:

```yaml
all:
  - original_filename: "birds.jpg"
    cloudflare_id: "4ad4209f-7a14-417c-f87b-baeae1710100"
    title: "birds"
    section: "portfolio"
    date: "2024-12-24"
    aspect: "3:02"
    alt: "Birds flying over the water in Florida"
```

**When adding new photos:**
1. Upload to Cloudflare Images (get UUID)
2. Add entry to `photos.yaml`
3. Create markdown file in appropriate section
4. Include both `cloudflare_id` and fallback `image` URL

### Responsive Image Pattern
Templates use `<picture>` elements with multiple variants:
- Mobile: `gridthumb` variant
- Desktop: `griddisplay` variant
- Full view: `full` variant

---

## Configuration Files

### `/config.toml` - Main Hugo Configuration

**Key Sections:**

1. **Custom Output Formats (AI-Specific)**
```toml
[outputFormats]
[outputFormats.AIIndex]
mediaType = "application/json"
baseName = "ai-index"
isPlainText = true

[outputs]
home = ["HTML", "RSS", "JSON", "AIIndex", "AIContent", "AINav"]
```

2. **Custom Taxonomies**
```toml
[taxonomies]
  category = "categories"
  writing_category = "writing_categories"
  music_category = "music_categories"
  genre = "genres"
```

3. **Navigation Menu**
- Home (weight: 1)
- Writing (weight: 2)
- Photos (weight: 3)
- Music (weight: 4)
- About (weight: 5)

4. **Minification**
- HTML: Minified aggressively
- CSS/JS: NOT minified (inline in templates)

### `/static/_headers` - Production HTTP Headers

**Security Headers:**
- Content Security Policy (CSP) allows Cloudflare, SoundCloud
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- Permissions-Policy blocks camera, microphone, geolocation

**Cache Control:**
- HTML: 1 hour (`max-age=3600`)
- Images: 1 year (`max-age=31536000`)
- AI endpoints: 2 hours (`max-age=7200`)

### `/static/robots.txt` - SEO & AI Crawler Configuration

**AI Crawlers Explicitly Allowed:**
- ClaudeBot
- GPTBot
- ChatGPT-User
- CCBot
- anthropic-ai
- PerplexityBot

**AI-Specific Endpoints:**
```
Allow: /ai-content.json
Allow: /ai-index.json
Allow: /ai-nav.json
```

---

## AI-First Architecture

### Custom JSON Endpoints

This site includes specialized JSON endpoints for AI assistants:

1. **`/ai-index.json`** - Full site index with metadata
2. **`/ai-content.json`** - All content with summaries and word counts
3. **`/ai-nav.json`** - Navigation structure
4. **`/ai-readme.json`** - Site documentation
5. **`/ai-sitemap.txt`** - Text-based sitemap

**Usage in AI context:**
These endpoints provide structured data about the entire site, making it easy for AI assistants to understand content without parsing HTML.

**Meta tags in HTML:**
```html
<meta name="ai-index" content="/ai-index.json">
<meta name="ai-content" content="/ai-content.json">
```

---

## Development Workflows

### Local Development
```bash
# Start Hugo development server
hugo server -D

# Build site for production
hugo

# Check for broken links or issues
hugo --gc --minify
```

### Adding New Content

**Individual Photo:**
```bash
# 1. Upload to Cloudflare Images, get UUID
# 2. Add to data/photos.yaml
# 3. Create markdown file
hugo new photos/photo-name.md
# 4. Edit front matter with cloudflare_id, image URL, alt text
```

**Photo Series:**
```bash
# 1. Upload all photos to Cloudflare, collect UUIDs
# 2. Create directory and index.md
mkdir -p content/portraits/subject-name
hugo new portraits/subject-name/index.md
# 3. Add series_images, series_cloudflare_ids, series_alt_texts arrays
```

**Essay/Poetry:**
```bash
hugo new writing/title-slug.md
# Edit front matter: set writing_categories, date, draft status
```

**Music Track:**
```bash
hugo new music/track-name.md
# Add soundcloud_url, genres, music_categories
```

### Fixing Typos
Use the automated script:
```bash
./fix-typos.sh
```

**Pattern:** Add new sed commands for common typos.

---

## Build & Deployment

### Build Process
```bash
hugo --gc --minify
```
Output: `/public/` directory

### Deployment
- **Platform:** Cloudflare Pages or Netlify
- **Build Command:** `hugo --gc --minify`
- **Publish Directory:** `public`
- **Environment Variables:** None required

### Headers & Caching
The `/static/_headers` file configures:
- Security policies (CSP, frame options)
- Cache durations (1 year for images, 1 hour for HTML)
- Special rules for AI endpoints

---

## Naming Conventions

### File Naming
- **Kebab-case** for all filenames and URLs
  - `content/writing/kick-drums-and-vsco-girls.md`
  - `content/portraits/alyssa/index.md`

### YAML Keys
- **snake_case** for all front matter keys
  - `writing_categories`
  - `series_cloudflare_ids`
  - `soundcloud_url`

### Hugo Template Functions
- **PascalCase** for Hugo functions
  - `.Site.BaseURL`
  - `.Params.Author`

---

## Common Tasks for AI Assistants

### Task 1: Add New Individual Photo
1. Get Cloudflare UUID and fallback URL from user
2. Add entry to `/data/photos.yaml`
3. Create markdown file in `content/photos/<name>.md`
4. Fill front matter with all required fields
5. **CRITICAL:** Include descriptive `alt` text for accessibility

### Task 2: Add New Photo Series
1. Get all Cloudflare UUIDs and fallback URLs
2. Create directory: `content/<section>/<series-name>/`
3. Create `index.md` with front matter
4. Add `series_images`, `series_cloudflare_ids`, `series_alt_texts` arrays
5. **CRITICAL:** Ensure all arrays have equal length

### Task 3: Add New Essay
1. Create `content/writing/<slug>.md`
2. Set `writing_categories: ["essay"]`
3. Add date and title
4. Set `draft: false` when ready to publish

### Task 4: Update Existing Content
1. **ALWAYS** read the file first
2. Preserve exact formatting and structure
3. Update only requested fields
4. Verify front matter syntax (proper YAML)

### Task 5: Fix Typos Across Multiple Files
1. Add sed command to `fix-typos.sh`
2. Test on specific file first
3. Run script to apply fixes
4. Verify changes with `git diff`

### Task 6: Add New Haiku
1. Create `content/writing/<haiku-name>.md`
2. Set `writing_categories: ["haiku"]`
3. Content should be 3 lines (5-7-5 syllables)
4. Homepage will automatically include in daily rotation

---

## Important Conventions

### Content Conventions
1. **Draft Management**
   - Use `draft: true` for unpublished content
   - Never commit unfinished work as `draft: false`

2. **Dates**
   - Use ISO 8601 format: `2025-09-16T11:23:36+02:00`
   - Can also use simple date: `2024-09-03`
   - Dates affect sorting and display order

3. **Categories vs Taxonomies**
   - `categories` - General categorization
   - `writing_categories` - Specific to writing (essay, poetry, haiku)
   - `music_categories` - Specific to music (mixes, productions)
   - `genres` - Music genres (house, techno, etc.)

### Photo Conventions
1. **Alt Text is MANDATORY**
   - Every photo must have descriptive alt text
   - Be specific: "Woman's boots in Berlin" not "boots"
   - Describe content, not artistic interpretation

2. **Cloudflare IDs**
   - Always UUID format: `e03d50d9-305b-467b-e186-16b2d6dd5a00`
   - Must match exactly (case-sensitive)
   - Available in Cloudflare Images dashboard

3. **Aspect Ratios**
   - Format in photos.yaml: `"3:02"`, `"4:02"`, etc.
   - Used for layout calculations
   - Keep as strings with leading zeros

### Code Style
1. **Templates**
   - Inline CSS (no separate stylesheets)
   - Minimal JavaScript (vanilla, no frameworks)
   - Use Hugo functions when possible

2. **Performance**
   - Lazy loading for images (except above-fold)
   - `fetchpriority="high"` for first image
   - Preconnect to `imagedelivery.net`

3. **Accessibility**
   - Alt text on all images
   - Semantic HTML
   - ARIA labels for icons

---

## Git Workflow

### Branch Strategy
- **Main branch:** `main` or `master`
- **Feature branches:** `claude/<feature-name>-<session-id>`

### Commit Guidelines
1. **Read git log** to match existing commit style
2. **Descriptive messages** focusing on "why" not "what"
3. **Atomic commits** - one logical change per commit
4. **Never commit secrets** (.env, credentials, API keys)

### Typical Commit Flow
```bash
# Check status
git status

# Review changes
git diff

# Stage relevant files
git add content/photos/new-photo.md
git add data/photos.yaml

# Commit with message
git commit -m "Add new photo: Essex Street

Added new portfolio photo from NYC subway. Updated photos.yaml with Cloudflare ID and metadata."

# Push to feature branch
git push -u origin claude/add-photo-xyz123
```

---

## Performance Optimizations

### Image Loading
- **Lazy loading** via `loading="lazy"` on all images except first
- **fetchpriority="high"** on above-fold images
- **Responsive variants** (gridthumb for mobile, griddisplay for desktop)
- **Intersection Observer** for SoundCloud embeds

### Homepage Optimizations
- **Random photo selection** via JavaScript (reduces staleness)
- **Daily haiku rotation** (parsed from date-based content)
- **Minimal initial payload** (inline CSS, no external dependencies)

### Build Optimizations
- **HTML minification** with aggressive settings
- **Resource hints** (preconnect to CDNs)
- **Long cache durations** (1 year for images)

---

## Security Considerations

### Content Security Policy (CSP)
- Allows self, Cloudflare, SoundCloud
- Blocks inline scripts except where needed
- `frame-ancestors: 'none'` prevents embedding

### Privacy
- No analytics or tracking (except Cloudflare Insights)
- Blocks FLoC and browsing topics
- Strict referrer policy

### Permissions
- Blocks camera, microphone, geolocation
- No access to user media devices

---

## Troubleshooting

### Common Issues

**Issue: Photo not displaying**
- Check `cloudflare_id` is correct UUID
- Verify fallback `image` URL is accessible
- Ensure alt text is present

**Issue: Photo series showing incorrectly**
- Verify `layout: "photo-series"` is set
- Check all arrays have equal length
- Confirm `series_cloudflare_ids` are valid UUIDs

**Issue: Content not appearing**
- Check `draft: false` is set
- Verify date is not in future
- Confirm file is in correct directory

**Issue: Build fails**
- Check YAML front matter syntax (indentation, quotes)
- Verify no unclosed tags in templates
- Run `hugo --gc --minify` locally to see errors

**Issue: Haiku not showing on homepage**
- Confirm `writing_categories: ["haiku"]`
- Check date format is valid
- Verify content is exactly 3 lines

---

## Testing Checklist

Before committing changes:

- [ ] Run `hugo server -D` locally and verify changes
- [ ] Check all new images load correctly
- [ ] Verify responsive layout (mobile + desktop)
- [ ] Test navigation links
- [ ] Validate alt text on all images
- [ ] Review `git diff` for unintended changes
- [ ] Check front matter YAML is valid
- [ ] Ensure no sensitive data in commits
- [ ] Verify draft status is correct
- [ ] Test build with `hugo --gc --minify`

---

## External Resources

### Documentation
- **Hugo Docs:** https://gohugo.io/documentation/
- **Cloudflare Images:** https://developers.cloudflare.com/images/
- **SoundCloud Embed:** https://developers.soundcloud.com/docs/api/html5-widget

### Tools
- **Hugo CLI:** https://gohugo.io/installation/
- **YAML Validator:** https://www.yamllint.com/
- **Markdown Linter:** https://github.com/DavidAnson/markdownlint

---

## Contact & Ownership

**Site Owner:** j.m. kettle
**Live Site:** https://jmkettle.com/
**Repository:** (Current repository)

---

## Version History

- **2026-01-20:** Initial CLAUDE.md created with comprehensive documentation
- Future updates should be logged here

---

## Final Notes for AI Assistants

1. **Always read before editing** - Never modify files without reading them first
2. **Preserve structure** - Maintain existing formatting and conventions
3. **Verify changes** - Test locally before committing
4. **Ask when uncertain** - If unclear about conventions, ask the user
5. **Be specific** - Provide file paths with line numbers when referencing code
6. **Respect the aesthetic** - This is a personal artistic portfolio; maintain the existing visual and content style
7. **Accessibility matters** - Never skip alt text or accessibility features
8. **Performance matters** - Maintain lazy loading and optimization patterns

When in doubt, follow the patterns established in existing content. This codebase is well-organized and consistent; your changes should match that quality.
