{{- with partial "render-image/resolve.html" . -}}
	{{- with partial "render-image/publish.html" . -}}
		{{- /* Plain-text output skips contextual escaping; HTMLToMarkdown parses this tag as HTML. */ -}}
		<img src="{{ .Permalink }}" alt="{{ $.PlainText | htmlEscape }}"{{ with $.Title }} title="{{ . | htmlEscape }}"{{ end }}>
	{{- end -}}
{{- end -}}
