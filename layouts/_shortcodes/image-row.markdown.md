{{- range split (strings.TrimSpace .Inner) "\n" -}}
	{{- with strings.TrimSpace . -}}
		<div>{{ . | $.Page.RenderString (dict "display" "block") }}</div>
	{{- end -}}
{{- end -}}
