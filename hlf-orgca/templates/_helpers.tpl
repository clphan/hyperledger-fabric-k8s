{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec). Supports the legacy fullnameOverride setting
as well as the global.orgName setting.
*/}}
{{- define "node.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.global.orgName -}}
{{- .Values.global.orgName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Sets extra deployment annotations
*/}}
{{- define "node.deployment.annotations" -}}
  {{- if .Values.node.annotations }}
  annotations:
    {{- $tp := typeOf .Values.node.annotations }}
    {{- if eq $tp "string" }}
      {{- tpl .Values.node.annotations . | nindent 4 }}
    {{- else }}
      {{- toYaml .Values.node.annotations | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end -}}
