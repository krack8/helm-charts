{{- /*
  Copyright Krack8, Inc. All Rights Reserved.
*/}}

{{- define "lighthouse.inputValidationCheck" }}
    {{- /*
        Global variables validation
    */}}
  {{- if and (not (empty .Values.global.ingress.tls.crt)) (empty .Values.global.ingress.tls.key) }}
    {{- fail "'global.ingress.tls.key' is required" }}
  {{- else if and (not (empty .Values.global.ingress.tls.key)) (empty .Values.global.ingress.tls.crt) }}
    {{- fail "'global.ingress.tls.crt' is required" }}
  {{- end }}

  {{- if and (not (empty .Values.global.ingressGrpc.tls.crt)) (empty .Values.global.ingressGrpc.tls.key) }}
    {{- fail "'global.ingressGrpc.tls.key' is required" }}
  {{- else if and (not (empty .Values.global.ingressGrpc.tls.key)) (empty .Values.global.ingressGrpc.tls.crt) }}
    {{- fail "'global.ingressGrpc.tls.crt' is required" }}
  {{- end }}


    {{- /*
        Server or Agent enabled validation check
    */}}
  {{- if and (eq .Values.server.enabled false) (eq .Values.agent.enabled false) }}
    {{- fail "'server.enabled' or 'agent.enabled' or both needs to be `true`" }}
  {{- end }}

    {{- /*
        Ingress configurations validation
    */}}
  {{- if eq .Values.server.ingress.enabled true }}
     {{- if (empty .Values.server.ingress.hostname) }}
        {{- fail "'server.ingress.hostname' is required" }}
     {{- end }}
  {{- end }}

  {{- if and (eq .Values.server.ingress.createCombinedIngress false) (.Values.server.webapp.ingress.enabled) (empty .Values.server.webapp.ingress.hostname) }}
    {{- fail "'server.webapp.ingress.hostname' is required" }}
  {{- end }}


    {{- /*
        Ingress gRPC configurations validation
    */}}
  {{- if eq .Values.server.ingressGrpc.enabled true }}
     {{- if (empty .Values.server.ingressGrpc.hostname) }}
        {{- fail "'server.ingressGrpc.hostname' is required" }}
     {{- end }}
  {{- end }}

    {{- /*
       Server TLS validation
    */}}
  {{- if eq .Values.server.ingress.tls.enabled true }}
     {{- if and (empty .Values.server.ingress.tls.secretName) (or (empty .Values.server.ingress.tls.crt) (empty .Values.server.ingress.tls.key)) }}
        {{- if and (empty .Values.global.ingress.tls.secretName) (or (empty .Values.global.ingress.tls.crt) (empty .Values.global.ingress.tls.key)) }}
            {{- fail "'server.ingress.tls.secretName' value or 'server.ingress.tls.crt' and 'server.ingress.tls.key' are required; you can also set 'global.ingress.tls.secretName' value or 'global.ingress.tls.crt' and 'global.ingress.tls.key'" }}
        {{- end }}
     {{- end }}
  {{- end }}

      {{- /*
       Webapp TLS validation
    */}}
  {{- if and (not .Values.server.ingress.createCombinedIngress) (eq .Values.server.webapp.ingress.tls.enabled true) }}
     {{- if and (empty .Values.server.webapp.ingress.tls.secretName) (or (empty .Values.server.webapp.ingress.tls.crt) (empty .Values.server.webapp.ingress.tls.key)) }}
        {{- if and (empty .Values.global.ingress.tls.secretName) (or (empty .Values.global.ingress.tls.crt) (empty .Values.global.ingress.tls.key)) }}
            {{- fail "'server.webapp.ingress.tls.secretName' value or 'server.webapp.ingress.tls.crt' and 'server.webapp.ingress.tls.key' are required; you can also set 'global.ingress.tls.secretName' value or 'global.ingress.tls.crt' and 'global.ingress.tls.key'" }}
        {{- end }}
     {{- end }}
  {{- else if and (.Values.server.ingress.createCombinedIngress) (eq .Values.server.webapp.ingress.tls.enabled true) }}
     {{- if and (empty .Values.server.ingress.tls.secretName) (or (empty .Values.server.ingress.tls.crt) (empty .Values.server.ingress.tls.key)) }}
        {{- if and (empty .Values.global.ingress.tls.secretName) (or (empty .Values.global.ingress.tls.crt) (empty .Values.global.ingress.tls.key)) }}
            {{- fail "the value of 'server.ingress.createCombinedIngress' set to 'true' but no tls information found under 'server.ingress.tls' nor 'global.ingress.tls'" }}
        {{- end }}
     {{- end }}
  {{- end }}

      {{- /*
       Server gRPC TLS validation
    */}}
  {{- if and (eq .Values.server.ingressGrpc.tls.useIngressTls false) (eq .Values.server.ingressGrpc.tls.enabled true) }}
     {{- if and (empty .Values.server.ingressGrpc.tls.secretName) (or (empty .Values.server.ingressGrpc.tls.crt) (empty .Values.server.ingressGrpc.tls.key)) }}
        {{- if and (empty .Values.global.ingressGrpc.tls.secretName) (or (empty .Values.global.ingressGrpc.tls.crt) (empty .Values.global.ingressGrpc.tls.key)) }}
            {{- fail "'server.ingressGrpc.tls.secretName' value or 'server.ingressGrpc.tls.crt' and 'server.ingressGrpc.tls.key' are required; you can also set 'global.ingressGrpc.tls.secretName' value or 'global.ingressGrpc.tls.crt' and 'global.ingressGrpc.tls.key'" }}
        {{- end }}
     {{- end }}
  {{- else if and (eq .Values.server.ingressGrpc.tls.useIngressTls true) (eq .Values.server.ingressGrpc.tls.enabled true) }}
     {{- if and (empty .Values.server.ingress.tls.secretName) (or (empty .Values.server.ingress.tls.crt) (empty .Values.server.ingress.tls.key)) }}
        {{- if and (empty .Values.global.ingress.tls.secretName) (or (empty .Values.global.ingress.tls.crt) (empty .Values.global.ingress.tls.key)) }}
            {{- fail "the value of 'server.ingressGrpc.tls.useIngressTls' set to 'true' but no tls information found under 'server.ingress.tls' nor 'global.ingress.tls'" }}
        {{- end }}
    {{- end }}
  {{- end }}


    {{- /*
        Agent validation
    */}}
  {{- if and (eq .Values.server.enabled false) (eq .Values.agent.enabled true) }}
    {{- if (empty .Values.auth.token) }}
        {{- fail "`auth.token` is required" }}
    {{- end }}
    {{- if (empty .Values.server.url) }}
        {{- fail "`server.url` is required" }}
    {{- end }}
    {{- if (empty .Values.agent.group) }}
        {{- fail "`agent.group` is required" }}
    {{- end }}
  {{- end }}
{{- end }}

