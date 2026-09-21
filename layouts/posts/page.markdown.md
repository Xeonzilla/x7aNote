{{- $body := .Content | transform.HTMLToMarkdown | strings.TrimSpace -}}
{{- $coverURL := "" -}}
{{- with partial "cover/context.html" . -}}
	{{- with partial "render-image/resolve.html" . -}}
		{{- with partial "render-image/publish.html" . -}}
			{{- $coverURL = .Permalink -}}
		{{- end -}}
	{{- end -}}
{{- end -}}
{{ partial "markdown/front-matter.html" (dict "page" . "coverURL" $coverURL) -}}
{{- printf "\n%s\n" $body -}}
