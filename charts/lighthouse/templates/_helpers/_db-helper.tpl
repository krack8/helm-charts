{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}
{{- define "lighthouse.db.mongo.name" -}}
{{- print "lighthouse-mongo" }}
{{- end }}

{{- define "lighthouse.db.mongo.headlessServiceName" -}}
{{- printf "%s" (include "lighthouse.db.mongo.name" .) }}
{{- end }}

{{- define "lighthouse.db.mongo.secretName" -}}
{{- printf "%s-secret" (include "lighthouse.db.mongo.name" .) }}
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
{{- if not (empty .Values.db.mongo.rootUser.username) -}}
{{- printf .Values.db.mongo.rootUser.username }}
{{- else -}}
{{- print "root" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.rootPassword" -}}
{{- if not (empty .Values.db.mongo.rootUser.password) -}}
{{- printf "%s" .Values.db.mongo.rootUser.password }}
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
{{- if .Values.db.mongo.uri -}}
{{- printf .Values.db.mongo.uri }}
{{- else if (eq .Values.db.mongo.create true) -}}
{{- printf "mongodb://%s:%s@%s:%s" (include "lighthouse.db.mongo.rootUsername" .) (include "lighthouse.db.mongo.rootPassword" .) (include "lighthouse.db.mongo.endpoint" .) (toString (include "lighthouse.db.mongo.port" .)) }}
{{- else -}}
{{- printf "mongodb://localhost:27017" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.endpoint" -}}
{{- printf "%s-0.%s.%s" (include "lighthouse.db.mongo.name" .) (include "lighthouse.db.mongo.headlessServiceName" .) (include "lighthouse.namespace" .) }}
{{- end }}

{{- define "lighthouse.db.mongo.databaseName" -}}
{{- if .Values.db.mongo.databaseName -}}
{{- printf .Values.db.mongo.databaseName }}
{{- else -}}
{{- printf "lighthouse" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.replicaCount" -}}
{{- .Values.db.mongo.replicaCount }}
{{- end }}

{{- define "lighthouse.db.mongo.image.repository" -}}
{{- if not (empty .Values.db.mongo.image.repository) -}}
{{- printf .Values.db.mongo.image.repository }}
{{- else }}
{{- printf "mongo" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.image.pullPolicy" -}}
{{- if not (empty .Values.db.mongo.image.pullPolicy) -}}
{{- printf .Values.db.mongo.image.pullPolicy }}
{{- else }}
{{- printf "IfNotPresent" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.image.tag" -}}
{{- if not (empty .Values.db.mongo.image.tag) -}}
{{- printf .Values.db.mongo.image.tag }}
{{- else }}
{{- print "latest" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.port" -}}
{{- .Values.db.mongo.port }}
{{- end }}

{{- define "lighthouse.db.mongo.targetPort" -}}
{{- .Values.db.mongo.targetPort }}
{{- end }}

{{- define "lighthouse.db.mongo.persistence.accessMode" -}}
{{- if not (empty .Values.db.mongo.persistence.accessMode) -}}
{{- printf .Values.db.mongo.persistence.accessMode }}
{{- else }}
{{- print "ReadWriteOnce" }}
{{- end }}
{{- end }}

{{- define "lighthouse.db.mongo.persistence.size" -}}
{{- printf .Values.db.mongo.persistence.size }}
{{- end }}


