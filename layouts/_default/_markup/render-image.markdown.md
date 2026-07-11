{{- with partial "render-image/resolve.html" . -}}
	{{- with partial "render-image/publish.html" . -}}
		<img src="{{ .Permalink }}" alt="{{ $.PlainText }}"{{ with $.Title }} title="{{ . }}"{{ end }}>
	{{- end -}}
{{- end -}}
