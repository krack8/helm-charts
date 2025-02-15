{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.controller.name" -}}
{{- printf .Values.controller.nameOverride | default "lighthouse-controller" }}
{{- end }}

{{- define "lighthouse.controller.configmap.name" -}}
{{- include "lighthouse.controller.name" . }}
{{- end }}

{{- define "lighthouse.controller.secret.name" -}}
{{- printf "%s-secret" (include "lighthouse.controller.name" .) }}
{{- end }}

{{- define "lighthouse.controller.ingress.name" -}}
{{- include "lighthouse.controller.name" . }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.name" -}}
{{- printf "%s-grpc" (include "lighthouse.controller.name" .) }}
{{- end }}

{{- define "lighthouse.controller.labels" -}}
{{ include "lighthouse.common.labels" . }}
{{ include "lighthouse.controller.selectorLabels" . }}
{{- end }}

{{- define "lighthouse.controller.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "lighthouse" }}
app.kubernetes.io/instance: {{ printf "controller" }}
{{- end }}

{{- define "lighthouse.controller.image.repository" -}}
{{- if .Values.controller.image.repository -}}
{{- printf .Values.controller.image.repository }}
{{- else -}}
{{- printf .Values.global.image.repository }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.image.pullPolicy" -}}
{{- if .Values.controller.image.pullPolicy -}}
{{- printf .Values.controller.image.pullPolicy }}
{{- else -}}
{{- printf .Values.global.image.pullPolicy }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.apiEndpoint" -}}
{{- if .Values.controller.apiEndpoint -}}
{{- printf .Values.controller.apiEndpoint }}
{{- else if and (eq .Values.controller.ingress.enabled true) -}}
{{- printf "%s://%s" (ternary "https" "http" (eq .Values.controller.ingress.tls.enabled true)) (.Values.controller.ingress.hostname) }}
{{- else -}}
{{- printf "http://%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.controller.service.port)  }}
{{- end }}
{{- end }}


{{- define "lighthouse.controller.grpc.url" -}}
{{- if .Values.controller.url -}}
{{- printf .Values.controller.url }}
{{- else -}}
{{- printf "%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.controller.grpc.port) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.secretName" -}}
{{- if .Values.controller.ingress.tls.secretName -}}
{{- print .Values.controller.ingress.tls.secretName }}
{{- else if .Values.global.ingress.tls.secretName -}}
{{- print .Values.global.ingress.tls.secretName }}
{{- else -}}
{{- printf "%s-tls" (include "lighthouse.controller.ingress.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.secretName" -}}
{{- if .Values.controller.ingressGrpc.tls.secretName -}}
{{- print .Values.controller.ingressGrpc.tls.secretName }}
{{- else if .Values.global.ingressGrpc.tls.secretName -}}
{{- print .Values.global.ingressGrpc.tls.secretName }}
{{- else -}}
{{- printf "%s-tls" (include "lighthouse.controller.ingressGrpc.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.crt" -}}
{{- if .Values.controller.ingress.tls.crt -}}
{{- print .Values.controller.ingress.tls.crt }}
{{- else -}}
{{- print .Values.global.ingress.tls.crt }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.key" -}}
{{- if .Values.controller.ingress.tls.key -}}
{{- print .Values.controller.ingress.tls.key }}
{{- else -}}
{{- print .Values.global.ingress.tls.key }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.ca" -}}
{{- if .Values.controller.ingress.tls.ca -}}
{{- print .Values.controller.ingress.tls.ca }}
{{- else -}}
{{- print .Values.global.ingress.tls.ca }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.crt" -}}
{{- if .Values.controller.ingressGrpc.tls.crt -}}
{{- print .Values.controller.ingressGrpc.tls.crt }}
{{- else -}}
{{- print .Values.global.ingressGrpc.tls.crt }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.key" -}}
{{- if .Values.controller.ingressGrpc.tls.key -}}
{{- print .Values.controller.ingressGrpc.tls.key }}
{{- else -}}
{{- print .Values.global.ingressGrpc.tls.key }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.ca" -}}
{{- if .Values.controller.ingressGrpc.tls.ca -}}
{{- print .Values.controller.ingressGrpc.tls.ca }}
{{- else -}}
{{- print .Values.global.ingressGrpc.tls.ca }}
{{- end }}
{{- end }}