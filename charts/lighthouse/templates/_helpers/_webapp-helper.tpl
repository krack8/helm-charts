{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.webapp.name" -}}
{{- printf "%s-webapp" (include "lighthouse.fullname" . ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.webapp.configmap.name" -}}
{{- include "lighthouse.webapp.name" . | trunc 63 | trimSuffix "-" }}
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
{{- if not (empty .Values.controller.webapp.image.repository) -}}
{{- printf .Values.controller.webapp.image.repository }}
{{- else if not (empty .Values.global.image.repository) -}}
{{- printf .Values.global.image.repository }}
{{- else }}
{{- printf "ghcr.io/krack8/lighthouse" }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.image.pullPolicy" -}}
{{- if not (empty .Values.controller.webapp.image.pullPolicy) -}}
{{- printf .Values.controller.webapp.image.pullPolicy }}
{{- else if not (empty .Values.global.image.pullPolicy) -}}
{{- printf .Values.global.image.pullPolicy }}
{{- else }}
{{- printf "IfNotPresent" }}
{{- end }}
{{- end }}

{{- define "lighthouse.webapp.image.tag" -}}
{{- if not (empty .Values.controller.webapp.image.tag) -}}
{{- printf .Values.controller.webapp.image.tag }}
{{- else }}
{{- printf "webapp-v%s" (.Chart.Version) }}
{{- end }}
{{- end }}