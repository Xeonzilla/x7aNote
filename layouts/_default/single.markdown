{{- $body := .RenderShortcodes -}}
{{- /* Replace standalone Markdown images with alt-text placeholders for presentation; resolve.html owns source URL safety. */ -}}
{{- $body = $body | replaceRE `(?m)^(> ?)?!\[([^\]]*)\]\([^\r\n]+\)[ \t]*\r?$` `$1[图片已省略：$2]` -}}
{{- $body = replace $body `[图片已省略：]` `[图片已省略]` -}}
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
