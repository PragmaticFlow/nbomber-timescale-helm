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
helm install my-nbomber-db timescale/timescale --version 0.1.0
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
- Randomly generated password (unless an existing secret is provided)
- 5Gi persistent volume

### Configuration

The following table lists the configurable parameters of the chart and their default values:

| Key                         | Type   | Default                 | Description                                   |
| --------------------------- | ------ | ----------------------- | --------------------------------------------- |
| `image.repository`          | string | `timescale/timescaledb` | Docker image repository                       |
| `image.tag`                 | string | `2.25.0-pg18-oss`       | Docker image tag                              |
| `image.pullPolicy`          | string | `IfNotPresent`          | Image pull policy                             |
| `resources.requests.memory` | string | `2Gi`                   | Memory request for the pod                    |
| `resources.limits.memory`   | string | `4Gi`                   | Memory limit for the pod                      |
| `service.type`              | string | `ClusterIP`             | Kubernetes service type                       |
| `service.port`              | int    | `5432`                  | Service port                                  |
| `persistence.size`          | string | `5Gi`                   | Persistent volume size                        |
| `persistence.storageClass`  | string | `""`                    | Storage class for PVC                         |
| `postgresql.user`           | string | `timescaledb`           | PostgreSQL username                           |
| `postgresql.database`       | string | `timescaledb`           | PostgreSQL database                           |
| `postgresql.password`       | string | `""`                    | PostgreSQL password (auto-generated if empty) |
| `postgresql.existingSecret` | string | `""`                    | Use an existing secret for credentials        |
| `nodeSelector`              | object | `{}`                    | Node selector for pod scheduling              |
| `affinity`                  | object | `{}`                    | Pod affinity rules                            |
| `tolerations`               | array  | `[]`                    | Pod tolerations                               |

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