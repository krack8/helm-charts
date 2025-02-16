{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.agent.name" -}}
{{- printf .Values.agent.nameOverride | default "lighthouse-agent" }}
{{- end }}

{{- define "lighthouse.agent.serviceAccount.name" -}}
{{ printf "lighthouse-agent-sa" }}
{{- end }}

{{- define "lighthouse.agent.clusterrole.name" -}}
{{ printf "lighthouse-agent-cr-%s" (include "lighthouse.namespace" .) }}
{{- end }}

{{- define "lighthouse.agent.clusterrolebinding.name" -}}
{{- printf "lighthouse-agent-crb-%s" (include "lighthouse.namespace" .) }}
{{- end }}

{{- define "lighthouse.agent.configmap.name" -}}
{{- include "lighthouse.agent.name" . }}
{{- end }}

{{- define "lighthouse.agent.secret.name" -}}
{{- printf "%s-secret" (include "lighthouse.agent.name" .) }}
{{- end }}

{{- define "lighthouse.agent.labels" -}}
{{ include "lighthouse.common.labels" . }}
{{ include "lighthouse.agent.selectorLabels" . }}
{{- end }}

{{- define "lighthouse.agent.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "lighthouse" }}
app.kubernetes.io/instance: {{ printf "agent" }}
{{- end }}

{{- define "lighthouse.agent.image.repository" -}}
{{- if .Values.agent.image.repository -}}
{{- printf .Values.agent.image.repository }}
{{- else -}}
{{- printf .Values.global.image.repository }}
{{- end }}
{{- end }}

{{- define "lighthouse.agent.image.pullPolicy" -}}
{{- if .Values.agent.image.pullPolicy -}}
{{- printf .Values.agent.image.pullPolicy }}
{{- else -}}
{{- printf .Values.global.image.pullPolicy }}
{{- end }}
{{- end }}
