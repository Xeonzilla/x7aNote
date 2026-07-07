---
name: gotmplfmt
description: Format Hugo template files with gotmplfmt after edits. Use after modifying Hugo templates under layouts or other .html, .htm, .xml, .svg, .rss, .atom, .gotmpl, .tmpl, or .txt template files; also use when layouts/_default/single.markdown changes.
---

# gotmplfmt

After editing auto-detected Hugo template files, run:

```powershell
gotmplfmt -w layouts
```

If `layouts\_default\single.markdown` changed, also run:

```powershell
gotmplfmt -w layouts\_default\single.markdown
```

Run formatting before the Hugo build. Trust formatter output.

Keep the generated front matter block in `layouts\_default\single.markdown` wrapped in `gotmplfmt-ignore-start/end`; front matter fields must stay at column 1.
