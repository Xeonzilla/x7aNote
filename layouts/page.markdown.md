{{- $body := .Content | transform.HTMLToMarkdown | strings.TrimSpace -}}
{{- $coverURL := "" -}}
{{- with partial "cover/context.html" . -}}
	{{- with partial "render-image/resolve.html" . -}}
		{{- with partial "render-image/publish.html" . -}}
			{{- $coverURL = .Permalink -}}
		{{- end -}}
	{{- end -}}
{{- end -}}
{{- $date := .Date.Format "2006-01-02" -}}
{{- $lastmod := .Lastmod.Format "2006-01-02" -}}
{{/* gotmplfmt-ignore-start */ -}}
---
title: {{ .Title | jsonify }}
date: {{ $date }}
{{ if ne $lastmod $date -}}
lastmod: {{ $lastmod }}
{{ end -}}
canonical: {{ .Permalink | jsonify }}
{{ with $coverURL -}}
cover: {{ . | jsonify }}
{{ end -}}
---
{{/* gotmplfmt-ignore-end */}}
{{- printf "\n%s" $body }}
