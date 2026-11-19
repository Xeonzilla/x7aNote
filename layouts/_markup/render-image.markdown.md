{{- with partial "render-image/resource.html" . -}}
	{{- /* Plain-text output skips contextual escaping; HTMLToMarkdown parses this tag as HTML. */ -}}
	<img src="{{ .Permalink }}" alt="{{ $.PlainText | htmlEscape }}"{{ with $.Title }} title="{{ . | htmlEscape }}"{{ end }}>
{{- end -}}
