{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}

{{- define "lighthouse.namespace" -}}
{{- default "lighthouse" .Release.Namespace | trunc 63 | trimSuffix "-"  }}
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

{{- define "auth.enabled" -}}
{{- if eq .Values.auth.enabled true -}}
{{- printf "TRUE" }}
{{- else -}}
{{- printf "FALSE" }}
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
{{- if not (empty .Values.global.ingress.apiVersion) -}}
{{- .Values.global.ingress.apiVersion -}}
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
{{- default (default .Capabilities.KubeVersion.Version) ((.Values.global).kubeVersion) -}}
{{- end -}}


{{- define "lighthouse.agent.wrokerGroup" -}}
{{- if .Values.agent.group -}}
{{- printf .Values.agent.group }}
{{- else -}}
{{- printf "DefaultGroup" }}
{{- end }}
{{- end }}

{{- define "lighthouse.agent.defaultClusterName" -}}
{{- if .Values.agent.defaultClusterName -}}
{{- printf .Values.agent.defaultClusterName }}
{{- else -}}
{{- printf "Default-cluster" }}
{{- end }}
{{- end }}
