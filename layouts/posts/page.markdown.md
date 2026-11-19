{{- $body := .Content | transform.HTMLToMarkdown | strings.TrimSpace -}}
{{- $coverURL := "" -}}
{{- with partial "cover/context.html" . -}}
	{{- with partial "render-image/resource.html" . -}}
		{{- $coverURL = .Permalink -}}
	{{- end -}}
{{- end -}}
{{ partial "markdown/front-matter.html" (dict "page" . "coverURL" $coverURL) -}}
{{- printf "\n%s\n" $body -}}
