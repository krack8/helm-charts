{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.agent.name" -}}
{{- printf "lighthouse-agent" }}
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

{{- define "lighthouse.agent.auth.secret.name" -}}
{{- printf "%s-auth-secret" (include "lighthouse.agent.name" .) }}
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
{{- if not (empty .Values.agent.image.repository) -}}
{{- printf .Values.agent.image.repository }}
{{- else if not (empty .Values.global.image.repository) -}}
{{- printf .Values.global.image.repository }}
{{- else }}
{{- printf "ghcr.io/krack8/lighthouse" }}
{{- end }}
{{- end }}

{{- define "lighthouse.agent.image.pullPolicy" -}}
{{- if not (empty .Values.agent.image.pullPolicy) -}}
{{- printf .Values.agent.image.pullPolicy }}
{{- else if not (empty .Values.global.image.pullPolicy) -}}
{{- printf .Values.global.image.pullPolicy }}
{{- else }}
{{- printf "IfNotPresent" }}
{{- end }}
{{- end }}

{{- define "lighthouse.agent.image.tag" -}}
{{- if not (empty .Values.agent.image.tag) -}}
{{- printf .Values.agent.image.tag }}
{{- else }}
{{- printf "agent-v1.0.0" }}
{{- end }}
{{- end }}
