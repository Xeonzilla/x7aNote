---
name: oxfmt
description: Format supported non-template project files with oxfmt after edits. Use after modifying Markdown, JSON, TOML, CSS, or other oxfmt-supported non-template files; do not use for Hugo templates under layouts or archetypes.
---

# oxfmt

After editing supported non-template files, format only changed files:

```powershell
oxfmt path\to\file.md
oxfmt path\to\file.json path\to\file.toml path\to\file.css
```

Do not run `oxfmt` on Hugo templates:

- `layouts/**`, including templates ending in `.markdown`, `.markdown.md`, or `.md`
- `archetypes/**`

Hugo archetypes are content templates. Validate them with temporary `hugo new content` output instead of formatting them.

The project `.oxfmtrc.json` intentionally protects template files. Do not add default-valued formatter options unless the user asks for a project style change.

If formatting writes Hugo output-affecting files such as content, CSS, TOML config, assets, or static files, follow the build rules in `AGENTS.md`.
