---
name: oxfmt
description: Format supported non-template project files with oxfmt after modifications. Use for Markdown, JSON, TOML, CSS, and other oxfmt-supported files in this repository; do not use for Hugo templates under layouts or archetypes.
---

# oxfmt Project Formatter

## Scope

Use `oxfmt` for supported non-template files, especially:

- Markdown: `*.md`
- JSON: `*.json`
- TOML: `*.toml`
- CSS: `*.css`

Do not use `oxfmt` for Hugo template files. This includes:

- `layouts/**`
- `layouts\_default\single.markdown`
- `archetypes/**`

Hugo archetypes such as `archetypes/*.md` are content templates, not plain
Markdown files. They may contain Go template expressions in front matter, and
Markdown formatters can corrupt those expressions or their YAML structure.
Validate archetypes by generating temporary content with `hugo new content`,
then remove the temporary content after inspection.

The project `.oxfmtrc.json` intentionally stays minimal and only protects
template files. Do not add default-valued options unless the user asks for a
project style change.

## Workflow

After modifying supported files, format only the files or directories you
changed:

```powershell
oxfmt path\to\file.md
oxfmt content\posts\example.md assets\css\base.css hugo.toml
```

Preview without writing when needed:

```powershell
oxfmt --check path\to\file.md
oxfmt --list-different path\to\dir
```

Do not run `oxfmt` against files under `archetypes/`. The repository ignore
rules exclude them, and `oxfmt --check archetypes\...` may exit non-zero only
because every matched file was intentionally ignored.

Use whole-repo checks sparingly because existing files may not all be formatted:

```powershell
oxfmt --check .
```

## Project Boundaries

- `public/` and `resources/` are generated and ignored through `.gitignore`.
- `.agents/skills/` documentation may be formatted with `oxfmt` after editing.
- If formatting writes Hugo output-affecting files such as content, CSS, TOML
  config, assets, or static files, follow the project verification rules in
  `AGENTS.md`.
