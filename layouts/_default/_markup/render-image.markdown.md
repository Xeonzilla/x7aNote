{{- $remoteImage := partial "render-image/resolve.html" . -}}
{{- with $remoteImage -}}
	{{- $image := partial "render-image/publish.html" . -}}
	{{- with $image -}}
		<img src="{{ .Permalink }}" alt="{{ $.PlainText }}"{{ with $.Title }} title="{{ . }}"{{ end }}>
	{{- end -}}
{{- end -}}
