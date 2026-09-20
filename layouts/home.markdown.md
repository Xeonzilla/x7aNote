{{- $collections := partial "home/collections.html" . -}}
{{- /* Markdown alternate of the home page: a machine-readable version of the article index below the HTML grid. */ -}}
{{- $latestLines := slice -}}
{{- range $page := $collections.latestPosts -}}
	{{- with $page.OutputFormats.Get "markdown" -}}
		{{- $latestLines = $latestLines | append (printf "- [%s](%s) (%s)" $page.Title .Permalink ($page.Date.Format "2006-01-02")) -}}
	{{- end -}}
{{- end -}}
{{- $updatedLines := slice -}}
{{- range $page := $collections.recentlyUpdatedPosts -}}
	{{- with $page.OutputFormats.Get "markdown" -}}
		{{- $updatedLines = $updatedLines | append (printf "- [%s](%s) (%s)" $page.Title .Permalink ($page.Lastmod.Format "2006-01-02")) -}}
	{{- end -}}
{{- end -}}
{{- $remainingLines := slice -}}
{{- range $group := $collections.remainingGroups -}}
	{{- $remainingLines = $remainingLines | append (printf "### %s" $group.Key) "" -}}
	{{- range $page := $group.Pages -}}
		{{- with $page.OutputFormats.Get "markdown" -}}
			{{- $remainingLines = $remainingLines | append (printf "- [%s](%s) (%s)" $page.Title .Permalink ($page.Date.Format "2006-01-02")) -}}
		{{- end -}}
	{{- end -}}
	{{- $remainingLines = $remainingLines | append "" -}}
{{- end -}}
{{/* gotmplfmt-ignore-start */ -}}
---
title: {{ site.Title | jsonify }}
canonical: {{ .Permalink | jsonify }}
---
{{/* gotmplfmt-ignore-end */ -}}
{{- $intro := printf "# %s\n\n> %s\n\nThis is the Markdown alternate of the home page. It lists the same articles as the HTML page, in the same order, and links each title to that article's Markdown alternate.\n\nSite guide:\n\n- Articles: every public article appears below; each title links to that article's Markdown alternate.\n- About: %s\n- Tags: %s\n- Atom feed: %s\n- Site guide: %s\n- Sitemap: %s\n\nHTML pages are canonical for human readers and use trailing slashes, such as %s and %s. A page's Markdown alternate sits at the same path with a .md suffix, such as %s or /<post-slug>.md, and its canonical HTML URL is that path without the suffix. Appending /index.md to an HTML path redirects to that page's Markdown alternate, for example /<post-slug>/index.md.\n" site.Title site.Params.description ("about/" | absURL) ("tags/" | absURL) ("feed.xml" | absURL) ("llms.txt" | absURL) ("sitemap.xml" | absURL) ("about/" | absURL) ("tags/hugo/" | absURL) ("about.md" | absURL) -}}
{{- printf "\n%s\n## 最近发布\n\n%s\n\n## 最近更新\n\n%s\n\n## 其他文章\n\n%s" $intro (delimit $latestLines "\n") (delimit $updatedLines "\n") (delimit $remainingLines "\n") -}}
