{{- $body := .Content | transform.HTMLToMarkdown | strings.TrimSpace -}}
{{ partial "markdown/front-matter.html" (dict "page" .) -}}
{{- printf "\n%s\n" $body -}}
