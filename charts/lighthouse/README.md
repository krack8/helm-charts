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
## Configuration and installation details

