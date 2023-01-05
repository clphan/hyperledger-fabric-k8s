{{- define "corda-node.labels" -}}
helm.sh/chart: {{ include "corda-node.chart" . }}
{{ include "corda-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "corda-node.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.node.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
