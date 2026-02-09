# TimescaleDB
A Helm chart for deploying a single-node TimescaleDB (OSS) instance for use with NBomber Studio.

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/timescale)](https://artifacthub.io/packages/search?repo=timescale)

## Overview
This chart deploys:
- A single-node TimescaleDB (OSS) StatefulSet
- A ClusterIP service for internal access
- Optional secret management for PostgreSQL credentials
- Persistent storage for database data

It is designed for simplicity and can be used in development, testing, or production environments.

### Installation

Add repository
```bash
helm repo add timescale https://pragmaticflow.github.io/nbomber-timescale-helm/
```

Install chart
```bash
helm install my-nbomber-db timescale/timescale --version 0.2.0
```

### Prerequisites
- Kubernetes 1.20+
- Helm 3+
- Sufficient resources for PostgreSQL:
    - At least 2Gi memory for testing
    - At least 4Gi memory limit recommended for heavier workloads

By default, this installs a TimescaleDB instance with:
- `timescaledb` database
- `timescaledb` user
- 5Gi persistent volume

> **Note:** You must provide either `postgresql.password` or `postgresql.existingSecret`.

### Configuration

The following table lists the configurable parameters of the chart and their default values:

| Parameter                           | Description                                         | Default                 |
| ----------------------------------- | --------------------------------------------------- | ----------------------- |
| `image.repository`                  | Docker image repository                             | `timescale/timescaledb` |
| `image.tag`                         | Docker image tag (defaults to Chart appVersion)     | `""`                    |
| `image.pullPolicy`                  | Image pull policy                                   | `IfNotPresent`          |
| `resources.requests.memory`         | Memory request for the pod                          | `2Gi`                   |
| `resources.limits.memory`           | Memory limit for the pod                            | `4Gi`                   |
| `service.type`                      | Kubernetes service type                             | `ClusterIP`             |
| `service.port`                      | Service port                                        | `5432`                  |
| `persistence.size`                  | Persistent volume size                              | `5Gi`                   |
| `persistence.storageClass`          | Storage class for PVC                               | `""`                    |
| `postgresql.user`                   | PostgreSQL username                                 | `timescaledb`           |
| `postgresql.database`              | PostgreSQL database                                 | `timescaledb`           |
| `postgresql.config.max_connections` | Maximum concurrent database connections             | `300`                   |
| `postgresql.password`              | PostgreSQL password (required if no existingSecret) | `""`                    |
| `postgresql.existingSecret`        | Use an existing secret for credentials              | `""`                    |
| `nameOverride`                      | Override chart name                                 | `""`                    |
| `fullnameOverride`                  | Override full resource name                         | `""`                    |
| `nodeSelector`                      | Node selector for pod scheduling                    | `{}`                    |
| `affinity`                          | Pod affinity rules                                  | `{}`                    |
| `tolerations`                       | Pod tolerations                                     | `[]`                    |

### Overriding Values

You can override any of these values in a `values.yaml` file:

```yaml
postgresql:
  user: timescaledb
  database: timescaledb
  password: supersecretpassword

persistence:
  size: 10Gi
```

Additionally you can attach your own secret or create a new one:

```bash
kubectl create secret generic my-timescale-credentials \  
  --from-literal=postgres-password=SuperSecret123  
```

```yaml
postgresql:
  existingSecret: "my-timescale-credentials"
  user: timescaledb
  database: timescaledb
  password: ""
```