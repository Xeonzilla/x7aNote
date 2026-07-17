---
name: gotmplfmt
description: Format Hugo template files with gotmplfmt after edits, including Markdown output layouts, render hooks, and shortcode templates under layouts ending in .markdown or .md.
---

# gotmplfmt

After editing auto-detected Hugo template files, run:

```powershell
gotmplfmt -w layouts
```

Directory scanning only discovers gotmplfmt's built-in template extensions; it does not discover files ending in `.markdown` or `.md`. Pass each changed Markdown output template explicitly. Collect them from the working tree instead of maintaining a hard-coded file list:

```powershell
$markdownTemplates = @(
  git diff --name-only --diff-filter=ACMRT HEAD -- layouts
  git ls-files --others --exclude-standard -- layouts
) | Sort-Object -Unique | Where-Object { $_ -match '\.(?:markdown|md)$' -and (Test-Path -LiteralPath $_) }

if ($markdownTemplates) {
  gotmplfmt -w $markdownTemplates
}
```

Run formatting before the Hugo build. Trust formatter output.

Keep generated front matter blocks in Markdown output templates wrapped in `gotmplfmt-ignore-start/end`; front matter fields must stay at column 1.
