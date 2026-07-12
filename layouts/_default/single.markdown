{{- $body := .Content | transform.HTMLToMarkdown | strings.TrimSpace -}}
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
---
{{/* gotmplfmt-ignore-end */}}
{{- printf "\n%s" $body }}
