{{- $body := .Content | transform.HTMLToMarkdown -}}
{{- $date := .Date.Format "2006-01-02" -}}
{{- $lastmod := "" -}}
{{- if not .Lastmod.IsZero -}}
	{{- $lastmod = .Lastmod.Format "2006-01-02" -}}
{{- end -}}
{{/* gotmplfmt-ignore-start */ -}}
---
title: {{ .Title | jsonify }}
date: {{ $date }}
{{ if and $lastmod (ne $lastmod $date) -}}
lastmod: {{ $lastmod }}
{{ end -}}
canonical: {{ .Permalink | jsonify }}
---
{{/* gotmplfmt-ignore-end */}}

{{ $body }}
