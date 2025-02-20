{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.controller.name" -}}
{{- printf "%s-controller" (include "lighthouse.fullname" . ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.controller.serviceAccount.name" -}}
{{ printf "%s-sa" (include "lighthouse.controller.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.controller.clusterrole.name" -}}
{{ printf "%s-cr-%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{- define "lighthouse.controller.clusterrolebinding.name" -}}
{{- printf "%s-crb-%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{- define "lighthouse.controller.configmap.name" -}}
{{- include "lighthouse.controller.name" . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.controller.secret.name" -}}
{{- printf "%s-secret" (include "lighthouse.controller.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.controller.ingress.name" -}}
{{- include "lighthouse.controller.name" . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.name" -}}
{{- printf "%s-grpc" (include "lighthouse.controller.name" .) | trunc 63 | trimSuffix "-" }}
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
{{- if not (empty .Values.controller.image.repository) -}}
{{- printf .Values.controller.image.repository }}
{{- else if not (empty .Values.global.image.repository) -}}
{{- printf .Values.global.image.repository }}
{{- else }}
{{- printf "ghcr.io/krack8/lighthouse" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.image.pullPolicy" -}}
{{- if not (empty .Values.controller.image.pullPolicy) -}}
{{- printf .Values.controller.image.pullPolicy }}
{{- else if not (empty .Values.global.image.pullPolicy) -}}
{{- printf .Values.global.image.pullPolicy }}
{{- else }}
{{- printf "IfNotPresent" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.image.tag" -}}
{{- if not (empty .Values.controller.image.tag) -}}
{{- printf .Values.controller.image.tag }}
{{- else }}
{{- print "controller-v1.0.0" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.apiEndpoint" -}}
{{- if .Values.controller.apiEndpoint -}}
{{- printf .Values.controller.apiEndpoint }}
{{- else if and (eq .Values.ingress.enabled true) -}}
{{- printf "%s://%s" (ternary "https" "http" (eq .Values.ingress.tls.enabled true)) (.Values.ingress.hostname) }}
{{- else -}}
{{- printf "http://%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.controller.service.port)  }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.grpc.url" -}}
{{- if eq .Values.ingressGrpc.enabled true -}}
{{- print .Values.ingressGrpc.hostname }}
{{- else -}}
{{- printf "%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.controller.grpc.port) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.secretName" -}}
{{- if .Values.ingress.tls.secretName -}}
{{- print .Values.ingress.tls.secretName }}
{{- else -}}
{{- printf "%s-tls" (include "lighthouse.controller.ingress.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.secretName" -}}
{{- if .Values.ingressGrpc.tls.secretName -}}
{{- print .Values.ingressGrpc.tls.secretName }}
{{- else }}
{{- printf "%s-tls" (include "lighthouse.controller.ingressGrpc.name" .) }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.crt" -}}
{{- if .Values.ingress.tls.crt -}}
{{- print .Values.ingress.tls.crt }}
{{- else -}}
{{- print "" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.key" -}}
{{- if .Values.ingress.tls.key -}}
{{- print .Values.ingress.tls.key }}
{{- else -}}
{{- print "" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingress.tls.ca" -}}
{{- if .Values.ingress.tls.ca -}}
{{- print .Values.ingress.tls.ca }}
{{- else -}}
{{- print "" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.crt" -}}
{{- if .Values.ingressGrpc.tls.crt -}}
{{- print .Values.ingressGrpc.tls.crt }}
{{- else -}}
{{- print "" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.key" -}}
{{- if .Values.ingressGrpc.tls.key -}}
{{- print .Values.ingressGrpc.tls.key }}
{{- else -}}
{{- print "" }}
{{- end }}
{{- end }}

{{- define "lighthouse.controller.ingressGrpc.tls.ca" -}}
{{- if .Values.ingressGrpc.tls.ca -}}
{{- print .Values.ingressGrpc.tls.ca }}
{{- else -}}
{{- print "" }}
{{- end }}
{{- end }}