---
name: gotmplfmt
description: Auto-format Hugo template files (.html, .tmpl) using gotmplfmt after modifications
---

# gotmplfmt Template Formatter

## When to Use

After creating or modifying template files with these extensions:

- `.html`, `.htm` - HTML templates
- `.xml`, `.svg` - XML/SVG templates
- `.rss`, `.atom` - Feed templates
- `.gotmpl`, `.tmpl` - Go templates
- `.txt` - Text templates

Primary directory: `layouts/**/*`

## Commands

### List files needing formatting

```powershell
gotmplfmt -l layouts
```

### Show formatting differences (preview)

```powershell
gotmplfmt -d layouts
```

### Format files (write changes)

```powershell
gotmplfmt -w layouts
```

### Format specific file

```powershell
gotmplfmt -w layouts\_default\single.html
```

### Format Markdown output template

`layouts\_default\single.markdown` is a Hugo template for generated Markdown output.
It is not picked up by directory formatting because `.markdown` is not an auto-detected
gotmplfmt extension. Format it explicitly only after modifying that file:

```powershell
gotmplfmt -w layouts\_default\single.markdown
```

Do not run this command after unrelated template edits; `gotmplfmt -w layouts` is enough
for the normal auto-detected layout templates.

Keep the generated front matter block wrapped in `gotmplfmt-ignore-start/end`;
front matter fields must stay at column 1, and gotmplfmt may indent literal
lines inside template conditionals.

### Format from stdin (for testing)

```powershell
cat template.html | gotmplfmt
```

## Ignore Directives

Use these comments to skip formatting:

```html
{{/* gotmplfmt-ignore-all */}}
<!-- Ignore entire file -->

{{/* gotmplfmt-ignore-start */}}
<!-- Complex manually-formatted code -->
{{/* gotmplfmt-ignore-end */}}
```

## Formatting Features

- **Indentation**: Uses tabs, not spaces
- **Idempotent**: Multiple runs produce same result
- **Preserved**: `<script>`, `<style>` blocks remain unformatted
- **Zero config**: No configuration needed, works out of the box

## Workflow

After modifying auto-detected template files, run:

```powershell
gotmplfmt -w layouts
```

This will automatically format all templates to match the formatter's standards.

If `layouts\_default\single.markdown` was modified, also run:

```powershell
gotmplfmt -w layouts\_default\single.markdown
```

## Notes

- gotmplfmt is installed globally
- Always trust the formatter's output
- Recursively processes directories, auto-detecting supported file types
