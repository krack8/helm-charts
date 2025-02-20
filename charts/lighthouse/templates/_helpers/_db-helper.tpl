{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.db.mongo.name" -}}
{{- printf "%s-mongo" (include "lighthouse.fullname" . ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.db.mongo.headlessServiceName" -}}
{{- include "lighthouse.db.mongo.name" .  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.db.mongo.secretName" -}}
{{- printf "%s-secret" (include "lighthouse.db.mongo.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lighthouse.db.mongo.persistence.name" -}}
{{- printf "datadir" }}
{{- end }}

{{- define "lighthouse.db.mongo.labels" -}}
{{ include "lighthouse.common.labels" . }}
{{ include "lighthouse.db.mongo.selectorLabels" . }}
{{- end }}

{{- define "lighthouse.db.mongo.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "lighthouse" }}
app.kubernetes.io/component: {{ printf "db" }}
app.kubernetes.io/instance: {{ printf "mongo" }}
{{- end }}

{{- define "lighthouse.db.mongo.rootUsername" -}}
{{- if not (empty .Values.db.mongo.internal.auth.username) -}}
{{- printf .Values.db.mongo.internal.auth.username }}
{{- else -}}
{{- print "root" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.rootPassword" -}}
{{- if not (empty .Values.db.mongo.internal.auth.password) -}}
{{- printf "%s" .Values.db.mongo.internal.auth.password }}
{{- else -}}
{{- $existingSecret := lookup "v1" "Secret" .Release.Namespace (include "lighthouse.db.mongo.secretName" .) -}}
{{- if $existingSecret -}}
{{- printf "%s" (index $existingSecret.data "MONGO_INITDB_ROOT_PASSWORD" | b64dec) -}}
{{- else -}}
{{- printf "mongo123!" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.uri" -}}
{{- if eq .Values.db.mongo.external.enabled true -}}
{{- printf .Values.db.mongo.external.uri }}
{{- else if eq .Values.db.mongo.internal.enabled true -}}
{{- printf "mongodb://%s:%s@%s:%s" (include "lighthouse.db.mongo.rootUsername" .) (include "lighthouse.db.mongo.rootPassword" .) (include "lighthouse.db.mongo.endpoint" .) (toString (include "lighthouse.db.mongo.port" .)) }}
{{- else -}}
{{- printf "mongodb://localhost:27017" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.endpoint" -}}
{{- printf "%s-0.%s.%s" (include "lighthouse.db.mongo.name" .) (include "lighthouse.db.mongo.headlessServiceName" .) (include "lighthouse.namespace" .) }}
{{- end }}

{{- define "lighthouse.db.mongo.databaseName" -}}
{{- if and (eq .Values.db.mongo.external.enabled true) (not (empty .Values.db.mongo.external.databaseName)) -}}
{{- printf .Values.db.mongo.external.databaseName }}
{{- else if and (eq .Values.db.mongo.internal.enabled true) (not (empty .Values.db.mongo.internal.auth.databaseName)) -}}
{{- printf .Values.db.mongo.internal.auth.databaseName }}
{{- else }}
{{- printf "lighthouse" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.replicaCount" -}}
{{- .Values.db.mongo.internal.replicaCount }}
{{- end }}

{{- define "lighthouse.db.mongo.image.repository" -}}
{{- if not (empty .Values.db.mongo.internal.image.repository) -}}
{{- printf .Values.db.mongo.internal.image.repository }}
{{- else }}
{{- printf "mongo" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.image.pullPolicy" -}}
{{- if not (empty .Values.db.mongo.internal.image.pullPolicy) -}}
{{- printf .Values.db.mongo.internal.image.pullPolicy }}
{{- else }}
{{- printf "IfNotPresent" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.image.tag" -}}
{{- if not (empty .Values.db.mongo.internal.image.tag) -}}
{{- printf .Values.db.mongo.internal.image.tag }}
{{- else }}
{{- print "7.0.16-jammy" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.port" -}}
{{- .Values.db.mongo.internal.port }}
{{- end }}

{{- define "lighthouse.db.mongo.targetPort" -}}
{{- .Values.db.mongo.internal.targetPort }}
{{- end }}

{{- define "lighthouse.db.mongo.persistence.accessMode" -}}
{{- if not (empty .Values.db.mongo.internal.persistence.accessMode) -}}
{{- printf .Values.db.mongo.internal.persistence.accessMode }}
{{- else }}
{{- print "ReadWriteOnce" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.persistence.size" -}}
{{- printf .Values.db.mongo.internal.persistence.size }}
{{- end }}


