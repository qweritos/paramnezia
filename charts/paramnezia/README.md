# paramnezia Helm Chart

Helm chart for running a privileged Paramnezia (Amnezia) instance on Kubernetes.

## Prerequisites

- Kubernetes cluster that allows privileged containers.
- A storage class (if `persistence.enabled=true`).

## Install

```bash
helm install paramnezia ./charts/paramnezia
```

## Upgrade

```bash
helm upgrade paramnezia ./charts/paramnezia
```

## Uninstall

```bash
helm uninstall paramnezia
```

## Firewall Rules via Values

The container startup setup script reads these env-backed values:

- `firewall.blockPrivateSubnets`:
  - `true` adds DROP rules for RFC1918 ranges (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`).
- `firewall.blockSubnets`:
  - additional CIDRs to block, passed as a list.

Example:

```yaml
firewall:
  blockPrivateSubnets: true
  blockSubnets:
    - 100.64.0.0/10
    - 203.0.113.0/24
```

## Key Values

| Key | Type | Default | Description |
|---|---|---|---|
| `replicaCount` | int | `1` | Number of pod replicas. |
| `image.repository` | string | `ghcr.io/qweritos/paramnezia` | Container image repository. |
| `image.tag` | string | `""` | Image tag, defaults to chart `appVersion` when empty. |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy. |
| `service.type` | string | `LoadBalancer` | Kubernetes service type. |
| `service.ports` | list | see `values.yaml` | Service and container ports for SSH and related protocols. |
| `securityContext.privileged` | bool | `true` | Runs container in privileged mode. |
| `firewall.blockPrivateSubnets` | bool | `false` | Enable RFC1918 subnet blocking. |
| `firewall.blockSubnets` | list | `[]` | Additional CIDRs to block in `DOCKER-USER`. |
| `persistence.enabled` | bool | `true` | Enable PVC for Docker data. |
| `persistence.size` | string | `20Gi` | PVC requested storage size. |
| `persistence.mountPath` | string | `/var/lib/docker` | Docker data mount path in container. |
| `hostPaths.sshHostKeys.enabled` | bool | `false` | Mount host `/etc/ssh`. |
| `hostPaths.rootSsh.enabled` | bool | `false` | Mount host `/root/.ssh`. |
| `serviceAccount.create` | bool | `true` | Create dedicated service account. |

## Notes

- Chart does not create RBAC roles/bindings.
- HostPath mounts are optional and disabled by default.
