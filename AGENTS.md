# x7aNote

> Hugo-based static blog with multi-agent support.

This file follows [llms.txt](https://llmstxt.org/) conventions for LLM-readable repository guidance.

## Scope

- These instructions apply to the entire repository unless a more specific `AGENTS.md` appears in a subdirectory.
- `CLAUDE.md` points to this file. Keep shared agent guidance here instead of duplicating it elsewhere.
- `.claude/skills/` is a symlink to `.agents/skills/`. Only modify files in `.agents/skills/`.
- Keep this file focused on durable repo rules. Put repeatable workflows in `.agents/skills/` when they need richer instructions.
- Treat this repository as a personal publishing system, not a general-purpose Hugo theme. Do not add configuration switches, compatibility branches, or reusable component APIs for hypothetical adopters; abstract only for multiple current consumers, a clear domain pipeline, or a replaceable external service boundary.

## Product Shape And Complexity

- Optimize the project for one author publishing and maintaining a personal blog, and for readers consuming it. Do not optimize for theme users, editors, administrators, plugins, or deployment targets that do not currently exist.
- The current product includes authored HTML pages, tag browsing, curated static comments, no-JS message submission, Atom and sitemap discovery, article Markdown alternates, machine-readable site guidance, canonical and social metadata, generated Open Graph images, accessible responsive presentation, and controlled remote image publication. Treat these as product surfaces rather than optional theme features.
- Preserve stable public URLs, readable content, media privacy, accessibility, and correct output across the formats the site actually publishes. Complexity that is necessary for those outcomes is justified even when the implementation is site-specific.
- Prefer the smallest Hugo-native implementation that expresses the current product. Direct template access, content-derived values, and a small amount of local duplication are preferable to forwarding wrappers, parallel data models, generic helpers, or configuration-driven indirection with no current choice to represent.
- Keep one source of truth for each fact. Do not store metadata that can be derived reliably from a content path, Hugo page data, or an existing configuration value.
- Add an abstraction only when it serves multiple current consumers, owns a coherent domain pipeline, or isolates a replaceable external service. A file or partial that merely renames values, forwards one call, or anticipates a second consumer is over-designed.
- Add a configuration value only when the maintainer can currently make a meaningful choice. Fixed layout decisions and stable implementation details belong with the code that owns them.
- Add a build-time rejection only when all three conditions hold: the mistake is plausible in the current authoring or deployment workflow; it could silently publish broken behavior, incorrect content relationships, or a security, privacy, or accessibility defect; and the failure can provide a specific actionable fix. Prefer Hugo's native failure, harmless normalization, omission, or preview for repository-owned constants, cosmetic differences, and hypothetical states.
- Do not reject harmless source differences solely to keep repository data pristine. Normalize them when the result is unambiguous and normalization materially helps output; otherwise accept them.
- Add permanent scripts, fixtures, compatibility branches, or test infrastructure only for recurring workflows or contracts that simpler build and output inspection cannot cover. Remove temporary audit machinery after use.
- Treat every external service, remote build dependency, alternate output format, and deployment hook as an ongoing maintenance cost. Keep it only while it provides a current author or reader benefit that is not simpler to provide locally.
- Complexity is measured across the whole maintenance path: authoring rules, content schema, templates, configuration, build behavior, deployment, and debugging. Line count alone does not make a feature too complex, and concise code does not justify an unnecessary feature.
- When a product decision removes a concept, remove its associated content metadata, archetypes, configuration, validation, documentation, and compatibility code in the same change. Do not leave dormant infrastructure for possible future reuse.
- Before adding or retaining complexity, be able to name its current consumer, the concrete failure or product limitation it addresses, and why a simpler Hugo-native approach is insufficient. If those answers are weak, simplify or omit it.

## Site Rules

- Keep the site static-first and Hugo-native. Prefer Hugo templates, render hooks, Markdown, static files, and no-JS external services.
- Do not add frontend JavaScript to the site implementation unless the user explicitly requests it. The deployed CSP uses `script-src 'none'`; historical article code samples are not part of this restriction.
- Do not edit generated output or caches directly: `public/`, `resources/`, and `.vercel_build_output/`.
- Keep `static/llms.txt` as the stable machine-readable site guide. Update it when changing the site title, author, base URL, feed path, sitemap path, or Markdown URL policy.
- Order Atom feed entries by effective activity time (`lastmod` when present, otherwise `date`); keep entry `<published>` at `date`, entry `<updated>` at effective activity time, and feed `<updated>` at the newest emitted activity.
- Use tags only. Do not introduce Hugo categories.
- Public displayed responses are called “评论”; submission entry points are called “留言”.
- Keep generated Open Graph titles complete and on one line. Do not extend the supported range by shrinking below the current minimum font size; recalibrate the guarded layout with boundary images if the font, canvas, or title design changes.

## URLs And Media

- HTML pages use trailing-slash URLs, such as `/post/`, `/tags/name/`, and `/message-sent/`.
- File outputs keep extensions, such as `/feed.xml`, `/sitemap.xml`, and `/post.md`.
- Publish remote images under `/images/` with hashed public filenames and extensions derived from Hugo media types.
- Reject remote image resources that lack image dimensions or a canonical media-type suffix.
- Markdown image sources must use relative paths resolved through `params.remote_images.base_url`.
- Do not use absolute image URLs, query strings, fragments, directory traversal, or generated URLs that expose original R2 paths, article slugs, or source filenames.
- Treat `security.http.mediaTypes` as trusted response types, not an allowlist. Keep `image/avif` trusted for the controlled image origin because Hugo cannot content-detect remote AVIF; `application/octet-stream` is required by the remote Open Graph fonts.
- Post cover images may intentionally use empty alt text such as `![](cover.avif)`; treat them as visual entry points, not missing-alt defects.
- Informative in-article images should use meaningful alt text.
- Use generated PNG Open Graph images only. Do not add manual Open Graph image overrides unless the project direction changes.

## Naming

- Follow host conventions for Hugo built-in keys and APIs, such as `baseURL`, `outputFormats`, and `.Lastmod`.
- Use `snake_case` for project-defined `params` keys in `hugo.toml`.
- Use lower camel case for Hugo template local variables, such as `$latestPostCount`.
- Use `kebab-case` for CSS classes, custom properties, shortcode names, asset filenames, and public URL segments.
- Keep content front matter short and lowercase where practical, especially existing content-facing keys such as `lastmod` and `replyto`.

## Tags

- Post front matter uses tag slugs, not display titles. Keep tag values lowercase `kebab-case`, such as `cloud-services`, `comment-system`, `media-mix`, and `tva-spring2025`.
- Keep official lowercase technical spellings in tag slugs, such as `vitepress`; do not use display casing like `VitePress` in front matter.
- Each used tag should have a matching `content/tags/<tag>/_index.md`.
- The term page `title` owns public display text, including localized Chinese titles and canonical casing such as `MediaMix`, `TVA`, `ONA`, and `vitepress`.
- Order article tags by meaning rather than alphabetically: primary subject or source medium first, presentation/adaptation medium next, season/detail tags immediately after their parent tag, implementation/environment tags after the concrete topic, and writing-nature tags such as `creation` or `reflection` last.
- Seasonal animation tags use the `tva-seasonYYYY` shape, for example `tva-spring2025`.
- Tags are recommended for posts when they add useful browsing structure, but they are not required. Untagged posts are acceptable when no existing tag fits or tagging would add noise.

## Layout Patterns

- Use `article-grid` for grids whose direct children are `article-card` entries. It owns the subgrid behavior that aligns article card dates and tag metadata across columns.
- Use `compact-list-grid` for outer grids of compact text lists, such as the tag overview page.
- Use `compact-list` for individual compact-list columns.
- Use `compact-list-columns.html` for the shared "split a linear collection into compact-list columns" behavior. Keep callers responsible for the outer grid so homepage archive sections can place year headings in the surrounding homepage grid.
- Prefer partials for clear domains or pipelines, such as `head/` and `render-image/`.
- For alternate output formats such as `feed` and `markdown`, prefer Hugo output-format-specific render hooks and shortcode templates over regex or string post-processing of `.Content`, `.RawContent`, or rendered HTML.
- Treat Markdown alternate image replacement as a presentation transform for standalone images, not as a general Markdown sanitizer; `render-image/resolve.html` owns source URL safety.
- Avoid tiny partials for a few lines of HTML when keeping the branch inline is easier to read.

## Build Toolchain

- Follow the latest stable Hugo release rather than pinning a repository-owned version. The maintainer keeps the local Hugo installation and Vercel `HUGO_VERSION` aligned.
- Keep the deployment-time latest-version check non-blocking. It supports the rolling-update policy but must not prevent an otherwise valid build when GitHub is unavailable or a new release has not yet been adopted.
- The repository does not promise that a clean clone can infer a historical Hugo version or reproduce an old commit with its original toolchain.

## Verification

- Run required formatters before builds. Report the meaningful verification commands in the final response.
- After modifying Hugo templates under `layouts/`, run:

```powershell
gotmplfmt -w layouts
```

- The directory scan above does not discover template files ending in `.markdown` or `.md`. Treat Markdown output layouts, render hooks, and shortcode templates under `layouts/` as Go templates, and pass each changed file explicitly. Current examples include:

```powershell
gotmplfmt -w layouts\_default\single.markdown layouts\_default\_markup\render-image.markdown.md layouts\shortcodes\image-row.markdown.md
```

- After modifying supported non-template files such as Markdown, JSON, TOML, or CSS, format only the changed files with `oxfmt`.
- After Hugo output-affecting changes, run the strict production build:

```powershell
hugo --environment production --cleanDestinationDir --panicOnWarning --printI18nWarnings --printPathWarnings --printUnusedTemplates --minify --gc
```

- Hugo output-affecting changes include Hugo config, content, layouts, assets, static files, shortcodes, render hooks, and anything else that can affect generated site output.
- Changes that do not affect Hugo output do not require a local clean strict Hugo build. This includes Vercel configuration, deployment metadata, documentation-only edits, agent instructions, repository housekeeping, and other non-Hugo files. Use targeted validation for those changes when relevant.
- For release checks, remote resource validation, or full content-state sweeps, run the deep strict build:

```powershell
hugo --environment production --cleanDestinationDir --panicOnWarning --printI18nWarnings --printPathWarnings --printUnusedTemplates --minify --gc --ignoreCache --buildDrafts --buildFuture --buildExpired
```

- Do not use `--quiet` for verification.
- Use `--templateMetrics --templateMetricsHints` only for template performance diagnostics, not for normal pass/fail checks.
- Treat the strict build as the baseline rather than proof of every output contract. Add targeted checks when a change can pass Hugo while still producing semantically wrong HTML, XML, Markdown, headers, images, links, or redirects.
- Use temporary content fixtures for relevant positive, negative, and boundary cases. Remove them after verification, and confirm the final strict build uses only tracked site content.
- Prefer direct inspection or parsing of representative generated outputs over adding a permanent test framework. Create a reusable script or skill only after the same audit workflow recurs often enough to justify maintaining it.

## Completion

- When a completed change or feature is coherent enough for its own commit, include a suggested commit message in the final response.
- Suggested commit messages must be English, start with a capital letter, stay brief and clear, and avoid Conventional Commits unless explicitly requested.
- If the turn is only an investigation, explanation, or partial status update, do not force a commit message.

## Skills

- [gotmplfmt](.agents/skills/gotmplfmt/SKILL.md): Format Hugo templates after edits.
- [oxfmt](.agents/skills/oxfmt/SKILL.md): Format supported non-template files after edits.
