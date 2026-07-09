# x7aNote

> Hugo-based static blog with multi-agent support.

This file follows [llms.txt](https://llmstxt.org/) conventions for LLM-readable repository guidance.

## Scope

- These instructions apply to the entire repository unless a more specific `AGENTS.md` appears in a subdirectory.
- `CLAUDE.md` points to this file. Keep shared agent guidance here instead of duplicating it elsewhere.
- `.claude/skills/` is a symlink to `.agents/skills/`. Only modify files in `.agents/skills/`.
- Keep this file focused on durable repo rules. Put repeatable workflows in `.agents/skills/` when they need richer instructions.

## Site Rules

- Keep the site static-first and Hugo-native. Prefer Hugo templates, render hooks, Markdown, static files, and no-JS external services.
- Do not add frontend JavaScript to the site implementation unless the user explicitly requests it. The deployed CSP uses `script-src 'none'`; historical article code samples are not part of this restriction.
- Do not edit generated output or caches directly: `public/`, `resources/`, and `.vercel_build_output/`.
- Keep `static/llms.txt` as the stable machine-readable site guide. Update it when changing the site title, author, base URL, feed path, sitemap path, or Markdown URL policy.
- Use tags only. Do not introduce Hugo categories.
- Public displayed responses are called “评论”; submission entry points are called “留言”.

## URLs And Media

- HTML pages use trailing-slash URLs, such as `/post/`, `/tags/name/`, and `/message-sent/`.
- File outputs keep extensions, such as `/feed.xml`, `/sitemap.xml`, and `/post.md`.
- Publish remote images under `/images/` with hashed public filenames.
- Markdown image sources should resolve through `params.remote_images.base_url`; use relative image paths for normal per-post remote image layout.
- Do not use image URLs outside `params.remote_images.base_url`, query strings, fragments, directory traversal, or generated URLs that expose original R2 paths, article slugs, or source filenames.
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
- Avoid tiny partials for a few lines of HTML when keeping the branch inline is easier to read.

## Verification

- Run required formatters before builds. Report the meaningful verification commands in the final response.
- After modifying Hugo templates under `layouts/`, run:

```powershell
gotmplfmt -w layouts
```

- If `layouts/_default/single.markdown` changed, also run:

```powershell
gotmplfmt -w layouts\_default\single.markdown
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

## Completion

- When a completed change or feature is coherent enough for its own commit, include a suggested commit message in the final response.
- Suggested commit messages must be English, start with a capital letter, stay brief and clear, and avoid Conventional Commits unless explicitly requested.
- If the turn is only an investigation, explanation, or partial status update, do not force a commit message.

## Skills

- [gotmplfmt](.agents/skills/gotmplfmt/SKILL.md): Format Hugo templates after edits.
- [oxfmt](.agents/skills/oxfmt/SKILL.md): Format supported non-template files after edits.
