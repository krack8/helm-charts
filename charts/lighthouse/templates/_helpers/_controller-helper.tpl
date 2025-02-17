{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.controller.name" -}}
{{- print "lighthouse-server" }}
{{- end }}

{{- define "lighthouse.controller.enabled" -}}
{{- if eq .Values.server.enabled true -}}
{{ print "true" }}
{{- else -}}
{{ print "false" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.serviceAccount.name" -}}
{{ printf "%s-sa" (include "lighthouse.controller.name" .) }}
{{- end }}

{{- define "lighthouse.controller.clusterrole.name" -}}
{{ printf "%s-cr-%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) }}
{{- end }}

{{- define "lighthouse.controller.clusterrolebinding.name" -}}
{{- printf "%s-crb-%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) }}
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
{{- if .Values.server.image.repository -}}
{{- printf .Values.server.image.repository }}
{{- else -}}
{{- printf .Values.global.image.repository }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.image.pullPolicy" -}}
{{- if .Values.server.image.pullPolicy -}}
{{- printf .Values.server.image.pullPolicy }}
{{- else -}}
{{- printf .Values.global.image.pullPolicy }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.apiEndpoint" -}}
{{- if .Values.server.apiEndpoint -}}
{{- printf .Values.server.apiEndpoint }}
{{- else if and (eq .Values.server.ingress.enabled true) -}}
{{- if and (eq .Values.server.ingress.createCombinedIngress true) -}}
{{- printf "%s://%s/server" (ternary "https" "http" (eq .Values.server.ingress.tls.enabled true)) (.Values.server.ingress.hostname) }}
{{- else -}}
{{- printf "%s://%s" (ternary "https" "http" (eq .Values.server.ingress.tls.enabled true)) (.Values.server.ingress.hostname) }}
{{- end }}
{{- else -}}
{{- printf "http://%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.server.service.port)  }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.grpc.url" -}}
{{- if .Values.server.url -}}
{{- printf .Values.server.url }}
{{- else if (eq .Values.server.ingressGrpc.enabled true) -}}
{{- print .Values.server.ingressGrpc.hostname }}
{{- else -}}
{{- printf "%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.server.grpc.port) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.secretName" -}}
{{- if .Values.server.ingress.tls.secretName -}}
{{- print .Values.server.ingress.tls.secretName }}
{{- else if .Values.global.ingress.tls.secretName -}}
{{- print .Values.global.ingress.tls.secretName }}
{{- else -}}
{{- printf "%s-tls" (include "lighthouse.controller.ingress.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.secretName" -}}
{{- if or (eq .Values.server.ingressGrpc.tls.useIngressTls true) (eq .Values.global.ingressGrpc.tls.useIngressTls true) -}}
{{- printf "%s" (include "lighthouse.controller.ingress.tls.secretName" .) }}
{{- else if .Values.server.ingressGrpc.tls.secretName -}}
{{- print .Values.server.ingressGrpc.tls.secretName }}
{{- else if .Values.global.ingressGrpc.tls.secretName -}}
{{- print .Values.global.ingressGrpc.tls.secretName }}
{{- else -}}
{{- printf "%s-tls" (include "lighthouse.controller.ingressGrpc.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.crt" -}}
{{- if .Values.server.ingress.tls.crt -}}
{{- print .Values.server.ingress.tls.crt }}
{{- else -}}
{{- print .Values.global.ingress.tls.crt }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.key" -}}
{{- if .Values.server.ingress.tls.key -}}
{{- print .Values.server.ingress.tls.key }}
{{- else -}}
{{- print .Values.global.ingress.tls.key }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.ca" -}}
{{- if .Values.server.ingress.tls.ca -}}
{{- print .Values.server.ingress.tls.ca }}
{{- else -}}
{{- print .Values.global.ingress.tls.ca }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.crt" -}}
{{- if .Values.server.ingressGrpc.tls.crt -}}
{{- print .Values.server.ingressGrpc.tls.crt }}
{{- else -}}
{{- print .Values.global.ingressGrpc.tls.crt }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.key" -}}
{{- if .Values.server.ingressGrpc.tls.key -}}
{{- print .Values.server.ingressGrpc.tls.key }}
{{- else -}}
{{- print .Values.global.ingressGrpc.tls.key }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.ca" -}}
{{- if .Values.server.ingressGrpc.tls.ca -}}
{{- print .Values.server.ingressGrpc.tls.ca }}
{{- else -}}
{{- print .Values.global.ingressGrpc.tls.ca }}
{{- end }}
{{- end }}