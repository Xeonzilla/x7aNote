{{- /* Markdown alternate of the home page: a machine-readable index of the same articles, in the same order, as the HTML grid. Everything below is literal output, so line breaks and trim markers are significant. */ -}}
{{- $collections := partial "home/collections.html" . -}}
{{/* gotmplfmt-ignore-start */ -}}
---
title: {{ site.Title | jsonify }}
canonical: {{ .Permalink | jsonify }}
---

# {{ site.Title }}

> {{ site.Params.description }}

This is the Markdown alternate of the home page. It lists the same articles as the HTML page, in the same order, and links each title to that article's Markdown alternate.

Site guide:

- Articles: every public article appears below; each title links to that article's Markdown alternate.
- About: {{ "about/" | absURL }}
- Tags: {{ "tags/" | absURL }}
- Atom feed: {{ "feed.xml" | absURL }}
- Site guide: {{ "llms.txt" | absURL }}
- Sitemap: {{ "sitemap.xml" | absURL }}

HTML pages are canonical for human readers and use trailing slashes, such as {{ "about/" | absURL }} and {{ (index (site.GetPage "tags").Pages 0).Permalink }}. Only the home page, the about page, and articles have Markdown alternates; each sits at its canonical path with a .md suffix, such as {{ "about.md" | absURL }} or /<post-slug>.md, and its canonical HTML URL is that path without the suffix. For the about page and articles, appending /index.md to the HTML path also redirects to the Markdown alternate, for example /<post-slug>/index.md.

## 最近发布

{{ range $collections.latestPosts -}}
- [{{ .Title }}]({{ (.OutputFormats.Get "markdown").Permalink }}) ({{ .Date.Format "2006-01-02" }})
{{ end }}
## 最近更新

{{ range $collections.recentlyUpdatedPosts -}}
- [{{ .Title }}]({{ (.OutputFormats.Get "markdown").Permalink }}) ({{ .Lastmod.Format "2006-01-02" }})
{{ end }}
## 其他文章
{{ range $collections.remainingGroups }}
### {{ .Key }}

{{ range .Pages -}}
- [{{ .Title }}]({{ (.OutputFormats.Get "markdown").Permalink }}) ({{ .Date.Format "2006-01-02" }})
{{ end -}}
{{ end -}}
{{/* gotmplfmt-ignore-end */ -}}
