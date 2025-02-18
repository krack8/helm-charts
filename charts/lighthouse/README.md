# Krack8 Lighthouse

## Introduction

This chart bootstraps a Krack8 Lighthouse deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteOnce volumes for database (if database creation required)

## Installing the Chart

To install the chart with the release name `krack8`:

```console
helm repo add krack8 https://krack8.github.io/helm-charts
```

The command pulls Krack8 charts on the Kubernetes cluster.

## Configuration and installation details

Lighthouse consists of three major components:

* **Lighthouse Server**: The core component that handles all incoming requests. Lighthouse server runs two serves: http server and grpc server.
* **Lighthouse Webapp**: A graphical user interface for visualizing clusters. It connects to the Lighthouse http server.
* **Lighthouse Agent**: Deployed inside each Kubernetes cluster to monitor its resources. Agent connects to the grpc Lighthouse server.

To install Lighthouse, you need to set up the server, webapp, and agents. You can install them using one of the following methods:

* **Full Installation**: Deploy all components (server, webapp, and agents) with a single command.
* **Server-Only Installation**: Set up only the Lighthouse server and webapp on a single cluster.
* **Agent-Only Installation**: Deploy only the Lighthouse agent inside a Kubernetes cluster.

### Resource requests and limits

Krack8 charts allow setting resource requests and limits for all containers inside the chart deployment.

To specify resources for all deployments, the Krack8 Lighthouse chart supports the `global.resources` field. Setting this field applies resource limits and requests to all deployments in the chart. 

For more granular control, the chart also allows defining resource requests and limits for specific deployments individually.

### Database

Krack8 Lighthouse chart integrate database to store metadata and other configurations. Currently, the chart Lighthouse supports mongodb database integration.

The chart allows to create database using `db.mongo.create`. Root user creds can also be provided for creation. It also possible to add existing mongo `db.mongo.uri`.

Chart allows db storage configuration including using `db.persistence`

The Krack8 Lighthouse chart integrates a database to store metadata and configuration details. Currently, it supports MongoDB integration.

The chart provides an option to create a new database using `db.mongo.create`, where root user credentials can also be specified during creation.

Alternatively, an existing MongoDB instance can be used by providing `db.mongo.uri`. It also allows configuring database storage through `db.persistence`.

### Ingress

The Krack8 Lighthouse chart provides support for Ingress resources to enable external access. If an Ingress controller is installed in your cluster, such as **nginx-ingress-controller**, **HAProxy**, or any other Ingress controller, it can be utilized to route traffic. Ingress is used to expose both the Lighthouse server and the webapp services.

To enable Ingress integration, set `server.ingress.enabled` to `true` for the server's HTTP Ingress, `server.webapp.ingress.enabled` to `true` for the webapp Ingress, and `server.ingressGrpc.enabled` to `true` for the server's gRPC Ingress. The chart also allows combining the server and webapp Ingress into a single resource by setting `server.ingress.createCombinedIngress` to `true`.

### Securing traffic using TLS

TLS support is also available for securing Ingress traffic. To enable TLS globally for both server and webapp, set `global.ingress.tls.enabled` to `true` or for individual configuration, specify `server.ingress.tls.enabled` and `server.webapp.ingress.tls.enabled` for HTTP Ingress.  For setting TLS globally for grpc ingress, set `global.ingressGrpc.tls.enabled` to `true` or `server.ingressGrpc.tls.enabled` to `true` for setting individually. 

The chart allows specifying certificates by providing `crt`, `key`, and `ca` (if necessary) as part of the TLS configuration. You can set certificates for server ingress, and the chart will create a secret. You can also provide existing secret `server.ingress.tls.secretName`. For grpc, if you want to
use the same tls secret as server ingress tls, set `server.ingressGrpc.tls.useIngressTls` to `true`.


## Parameters

### Global parameters

| Name                      | Description                                                                          | Value                        |
|---------------------------|--------------------------------------------------------------------------------------|------------------------------|
| `global.runMode`          | Run mode for Lighthouse services (options: `PRODUCTION`, `DEVELOP`)                  | `"PRODUCTION"`               |
| `global.image.repository` | Global Docker image repository                                                       | `quay.io/klovercloud/krack8` |
| `global.image.pullPolicy` | Global Docker image pull policy                                                      | `IfNotPresent`               |
| `global.resources`        | Global resource (limit,request) section for containers inside Lighthouse deployments | `{}`                         |




