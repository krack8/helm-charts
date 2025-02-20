{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}

{{- define "lighthouse.inputValidationCheck" }}
    {{- /*
        Controller or Agent enabled validation check
    */}}
  {{- if and (eq .Values.controller.enabled false) (eq .Values.agent.enabled false) }}
    {{- fail "'controller.enabled' or 'agent.enabled' or both needs to be `true`" }}
  {{- end }}

    {{- /*
        Database Values
    */}}
  {{- if and (eq .Values.db.mongo.external.enabled true) (empty .Values.db.mongo.external.uri) }}
    {{- fail "'db.mongo.external.uri' is required" }}
  {{- end }}

  {{- if and (eq .Values.db.mongo.external.enabled true) (empty .Values.db.mongo.external.databaseName) }}
    {{- fail "'db.mongo.external.databaseName' is required" }}
  {{- end }}

  {{- if and (eq .Values.db.mongo.external.enabled false) (eq .Values.db.mongo.internal.enabled false) }}
    {{- fail "'db.mongo.internal.enabled' or 'db.mongo.external.enabled' must be set to 'true'" }}
  {{- end }}

    {{- /*
        Ingress configurations validation
    */}}
  {{- if eq .Values.ingress.enabled true }}
     {{- if (empty .Values.ingress.hostname) }}
        {{- fail "'ingress.hostname' is required" }}
     {{- end }}
  {{- end }}

    {{- /*
        Ingress gRPC configurations validation
    */}}
  {{- if eq .Values.ingressGrpc.enabled true }}
     {{- if (empty .Values.ingressGrpc.hostname) }}
        {{- fail "'ingressGrpc.hostname' is required" }}
     {{- end }}
  {{- end }}

    {{- /*
       TLS validation
    */}}
  {{- if eq .Values.ingress.tls.enabled true }}
     {{- if and (empty .Values.ingress.tls.secretName) (or (empty .Values.ingress.tls.crt) (empty .Values.ingress.tls.key)) }}
        {{- fail "'ingress.tls.secretName' value or 'ingress.tls.crt' and 'ingress.tls.key' are required" }}
     {{- end }}
  {{- end }}

  {{- if eq .Values.ingressGrpc.tls.enabled true }}
     {{- if and (empty .Values.ingressGrpc.tls.secretName) (or (empty .Values.ingressGrpc.tls.crt) (empty .Values.ingressGrpc.tls.key)) }}
        {{- fail "'ingressGrpc.tls.secretName' value or 'ingressGrpc.tls.crt' and 'ingressGrpc.tls.key' are required" }}
     {{- end }}
  {{- end }}

    {{- /*
        Agent validation
    */}}
  {{- if and (eq .Values.controller.enabled false) (eq .Values.agent.enabled true) }}
    {{- if (empty .Values.auth.token) }}
        {{- fail "`auth.token` is required" }}
    {{- end }}
    {{- if (empty .Values.config.controller.grpc.host) }}
        {{- fail "`config.controller.grpc.host` is required" }}
    {{- end }}
    {{- if (empty .Values.agent.group) }}
        {{- fail "`agent.group` is required" }}
    {{- end }}
  {{- end }}
{{- end }}

