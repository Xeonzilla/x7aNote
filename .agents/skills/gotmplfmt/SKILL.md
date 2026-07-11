---
name: gotmplfmt
description: Format Hugo template files with gotmplfmt after edits, including Markdown output layouts, render hooks, and shortcode templates under layouts with .markdown or .markdown.md names.
---

# gotmplfmt

After editing auto-detected Hugo template files, run:

```powershell
gotmplfmt -w layouts
```

Directory scanning only discovers gotmplfmt's built-in template extensions; it does not discover files ending in `.markdown` or `.md`. Pass each changed Markdown output template explicitly. Current examples include:

```powershell
gotmplfmt -w layouts\_default\single.markdown layouts\_default\_markup\render-image.markdown.md layouts\shortcodes\image-row.markdown.md
```

Run formatting before the Hugo build. Trust formatter output.

Keep the generated front matter block in `layouts\_default\single.markdown` wrapped in `gotmplfmt-ignore-start/end`; front matter fields must stay at column 1.
