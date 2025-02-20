{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}

{{- define "lighthouse.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "lighthouse.namespace" -}}
{{- default "lighthouse" .Release.Namespace | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{- define "lighthouse.cleanup.job.name" -}}
{{- printf "%s-cleanup-job" (include "lighthouse.fullname" . ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.common.labels" -}}
helm.sh/chart: {{ include "lighthouse.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ "Helm" }}
{{- end }}

{{- define "lighthouse.user.email" -}}
{{- if .Values.user.email -}}
{{- printf .Values.user.email }}
{{- else -}}
{{- printf "admin@default.com" }}
{{- end }}
{{- end }}

{{- define "lighthouse.user.password" -}}
{{- if .Values.user.password -}}
{{- printf .Values.user.password }}
{{- else -}}
{{- printf "admin123" }}
{{- end }}
{{- end }}

{{/*
     the appropriate apiVersion for ingress.
*/}}
{{- define "rbac.apiVersion" -}}
{{- $kubeVersion := include "kubeVersion" . -}}
{{- if and (not (empty $kubeVersion)) (semverCompare "<1.17-0" $kubeVersion) -}}
{{- print "rbac.authorization.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "rbac.authorization.k8s.io/v1" -}}
{{- end -}}
{{- end -}}


{{- define "ingress.apiVersion" -}}
{{- if not (empty .Values.ingress.apiVersion) -}}
{{- .Values.ingress.apiVersion -}}
{{- else -}}
{{- $kubeVersion := include "kubeVersion" . -}}
{{- if and (not (empty $kubeVersion)) (semverCompare "<1.14-0" $kubeVersion) -}}
{{- print "extensions/v1beta1" -}}
{{- else if and (not (empty $kubeVersion)) (semverCompare "<1.19-0" $kubeVersion) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end }}
{{- end }}

{{- define "ingress.supportsPathType" -}}
{{- if (semverCompare "<1.18-0" (include "kubeVersion" .)) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{- define "ingress.supportsIngressClassname" -}}
{{- if semverCompare "<1.18-0" (include "kubeVersion" .) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{- define "ingress.backend" -}}
{{- $apiVersion := .ingressApiVersion -}}
{{- if or (eq $apiVersion "extensions/v1beta1") (eq $apiVersion "networking.k8s.io/v1beta1") -}}
serviceName: {{ .serviceName }}
servicePort: {{ .servicePort }}
{{- else -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if or (typeIs "int" .servicePort) (typeIs "float64" .servicePort) }}
    number: {{ .servicePort | int }}
    {{- end }}
{{- end -}}
{{- end -}}

{{- define "ingress.tls.secretName" -}}
{{- if .existingSecretName -}}
{{ print .existingSecretName }}
{{- else -}}
{{ print "hudaiPainai" }}
{{- end -}}
{{- end -}}

{{- define "kubeVersion" -}}
{{- default (default .Capabilities.KubeVersion.Version) ((.Values).kubeVersion) -}}
{{- end -}}


{{- define "lighthouse.agent.wrokerGroup" -}}
{{- if and (eq .Values.controller.enabled false) (eq .Values.agent.enabled true) -}}
{{- if .Values.agent.group -}}
{{- printf .Values.agent.group }}
{{- end }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "lighthouse.agent.defaultClusterName" -}}
{{- if .Values.agent.defaultClusterName -}}
{{- printf .Values.agent.defaultClusterName }}
{{- else -}}
{{- printf "Default-cluster" }}
{{- end }}
{{- end }}

{{- define "lighthouse.contoller.grpc.tls.enabled" -}}
{{- if and (eq .Values.controller.enabled true) (eq .Values.agent.enabled true) -}}
{{ printf "False" }}
{{- else if eq .Values.config.controller.grpc.tls.enabled true -}}
{{ printf "True" }}
{{- else -}}
{{ printf "False" }}
{{- end }}
{{- end }}

{{- define "lighthouse.contoller.grpc.tls.skipVerification" -}}
{{- if and (eq .Values.controller.enabled true) (eq .Values.agent.enabled true) -}}
{{ printf "True" }}
{{- else if eq .Values.config.controller.grpc.tls.skipVerification true -}}
{{ printf "True" }}
{{- else -}}
{{ printf "False" }}
{{- end }}
{{- end }}

{{- define "lighthouse.config.controller.grpc.url" -}}
{{- if and (eq .Values.controller.enabled true) (eq .Values.agent.enabled true) -}}
{{- printf "%s.%s:%s" (include "lighthouse.controller.name" .) (include "lighthouse.namespace" .) (toString .Values.controller.grpc.port) }}
{{- else -}}
{{- printf .Values.config.controller.grpc.host }}
{{- end }}
{{- end }}

