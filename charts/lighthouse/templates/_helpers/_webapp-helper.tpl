{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.webapp.name" -}}
{{- printf .Values.webapp.nameOverride | default "lighthouse-webapp" }}
{{- end }}

{{- define "lighthouse.webapp.configmap.name" -}}
{{- include "lighthouse.webapp.name" . }}
{{- end }}

{{- define "lighthouse.webapp.ingress.name" -}}
{{- include "lighthouse.webapp.name" . }}
{{- end }}

{{- define "lighthouse.webapp.labels" -}}
{{ include "lighthouse.common.labels" . }}
{{ include "lighthouse.webapp.selectorLabels" . }}
{{- end }}

{{- define "lighthouse.webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "lighthouse" }}
app.kubernetes.io/instance: {{ printf "webapp" }}
{{- end }}

{{- define "lighthouse.webapp.image.repository" -}}
{{- if .Values.webapp.image.repository -}}
{{- printf .Values.webapp.image.repository }}
{{- else -}}
{{- printf .Values.global.image.repository }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.image.pullPolicy" -}}
{{- if .Values.webapp.image.pullPolicy -}}
{{- printf .Values.webapp.image.pullPolicy }}
{{- else -}}
{{- printf .Values.global.image.pullPolicy }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.ingress.tls.secretName" -}}
{{- if .Values.webapp.ingress.tls.secretName -}}
{{- print .Values.webapp.ingress.tls.secretName }}
{{- else if .Values.global.ingress.tls.secretName -}}
{{- print .Values.global.ingress.tls.secretName }}
{{- else -}}
{{- printf "%s-tls" (include "lighthouse.webapp.ingress.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.ingress.tls.crt" -}}
{{- if .Values.webapp.ingress.tls.crt -}}
{{- print .Values.webapp.ingress.tls.crt }}
{{- else -}}
{{- print .Values.global.ingress.tls.crt }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.ingress.tls.key" -}}
{{- if .Values.webapp.ingress.tls.key -}}
{{- print .Values.webapp.ingress.tls.key }}
{{- else -}}
{{- print .Values.global.ingress.tls.key }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.ingress.tls.ca" -}}
{{- if .Values.webapp.ingress.tls.ca -}}
{{- print .Values.webapp.ingress.tls.ca }}
{{- else -}}
{{- print .Values.global.ingress.tls.ca }}
{{- end }}
{{- end }}