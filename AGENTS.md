# x7aNote

> Hugo-based static personal blog.

## Scope And Product

- These instructions apply to the whole repository unless a nested `AGENTS.md` overrides them. `CLAUDE.md` points here; keep shared guidance in this file.
- Treat the repository as one author's publishing system, not a reusable Hugo theme. Optimize for the current author and readers, not hypothetical users, plugins, browsers, or deployment targets.
- The product includes HTML pages, tags, curated static comments, no-JS message submission, Atom and sitemap discovery, article Markdown alternates, `llms.txt`, generated Open Graph images, accessible responsive presentation, and controlled remote image publication.
- Keep the site static-first and Hugo-native. Do not add frontend JavaScript unless explicitly requested; the deployed CSP uses `script-src 'none'`.
- Preserve stable public URLs, readable content, accessibility, media privacy, and correct output across every published format.
- Prefer direct Hugo data and the smallest current implementation. Keep one source of truth; do not add forwarding wrappers, parallel data models, feature switches without a real choice, or compatibility code for hypothetical needs.
- Add an abstraction only for multiple current consumers, a coherent domain pipeline, or a replaceable external service boundary. Small local duplication is preferable to premature indirection.
- Add build-time rejection only for plausible workflow mistakes that could silently publish broken relationships or security, privacy, or accessibility defects and that have a specific fix. Accept or normalize harmless differences; rely on Hugo, omission, or preview for stable internal constants and hypothetical states.
- Treat scripts, tests, external services, remote build dependencies, alternate formats, and deployment hooks as maintenance costs. Keep them only for recurring workflows or current author/reader value.
- When removing a product concept, remove its metadata, archetypes, configuration, validation, documentation, and compatibility code in the same change.

## Content And Output Contracts

- Do not edit generated output or caches: `public/`, `resources/`, or `.vercel_build_output/`.
- Use tags only. Post tag values are lowercase `kebab-case` slugs, and every used tag has `content/tags/<slug>/_index.md`; the term page title owns public display casing. Order tags by meaning, with broad subject first and writing-nature tags last.
- Public responses are “评论”; submission entry points are “留言”. Comments live at `content/comments/<post-slug>/<nn>.md`, use continuous two-digit numbering, and do not support images.
- Atom entries are ordered by effective activity (`lastmod`, otherwise `date`). Keep `<published>` at `date`, entry `<updated>` at effective activity, and feed `<updated>` at the newest emitted activity.
- HTML pages use trailing slashes; file outputs keep extensions. Internal Markdown links use current root-relative canonical paths or fragments and must resolve; page-relative links are unsupported.
- Markdown image sources are relative paths resolved through `params.remote_images.base_url`. Reject absolute URLs, query strings, fragments, traversal, missing dimensions, or missing canonical media suffixes.
- Publish remote images under `/images/` with hashed filenames. Public output must not expose source object paths, article slugs, or source filenames.
- Keep `image/avif` and `application/octet-stream` trusted in `security.http.mediaTypes`; they are required for controlled AVIF images and remote Open Graph fonts.
- Empty alt text is allowed for post cover images; informative article images need meaningful alt text.
- Open Graph images are generated PNGs. Keep article titles complete and on one line; do not shrink below the current minimum font size without recalibrating boundary images.
- Update `static/llms.txt` when changing the site title, author, base URL, Feed or sitemap paths, or Markdown URL policy.

## Implementation

- Follow Hugo's naming for built-ins. Use `snake_case` for project `params`, lower camel case for template locals, and `kebab-case` for CSS classes, shortcodes, assets, and public URL segments.
- Prefer output-format-specific render hooks and shortcodes for HTML, Feed, and Markdown instead of post-processing rendered content.
- Use partials for real domains and pipelines; keep short one-off markup inline.
- Preserve the existing `article-grid`, `compact-list-grid`, `compact-list`, and `compact-list-columns.html` ownership patterns when editing those layouts.
- Follow the latest stable Hugo release. Keep the deployment version check non-blocking and the local and Vercel versions aligned.
- `.claude/skills/` points to `.agents/skills/`; modify only `.agents/skills/`. Put reusable workflows in skills rather than expanding this file.

## Verification

- Run required formatters before builds and report meaningful verification in the final response.
- After changing templates under `layouts/`, run `gotmplfmt -w layouts`. Also pass each changed template ending in `.markdown` or `.md` explicitly because directory scanning does not find them.
- After changing supported Markdown, JSON, TOML, or CSS files, run `oxfmt` only on the changed files. Do not use it for Hugo templates or archetypes.
- After output-affecting changes, run:

```powershell
hugo --environment production --cleanDestinationDir --panicOnWarning --printI18nWarnings --printPathWarnings --printUnusedTemplates --minify --gc
```

- For release checks, remote-resource validation, or full content sweeps, add `--ignoreCache --buildDrafts --buildFuture --buildExpired`.
- Documentation, agent guidance, deployment metadata, and other non-output changes do not require a Hugo build; use targeted validation instead.
- A successful build is only the baseline. Inspect representative HTML, XML, Markdown, headers, images, links, or redirects when the changed contract needs it. Use temporary fixtures for relevant positive, negative, and boundary cases, then remove them.

## Completion

- Preserve unrelated user changes and never edit generated output directly.
- For a coherent completed change, suggest a brief English commit message that starts with a capital letter and is not Conventional Commits unless requested.
