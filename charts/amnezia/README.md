# amnezia Helm Chart

Helm chart for running a privileged Amnezia instance on Kubernetes.

This chart uses the Docker image from the `paramnezia` project:
https://github.com/qweritos/paramnezia

## Prerequisites

- Kubernetes cluster that allows privileged containers. # todo: review privileges set
- A storage class (if `persistence.enabled=true`).

## Install

```bash
helm install amnezia oci://registry.andrey.wtf/charts/amnezia
```

## Upgrade

```bash
helm upgrade amnezia oci://registry.andrey.wtf/charts/amnezia
```

## Uninstall

```bash
helm uninstall amnezia
```

## Firewall Rules via Values

The container startup setup script reads these env-backed values:

- `firewall.blockPrivateSubnets`:
  - `true` adds DROP rules for RFC1918 ranges
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

## Ingress (SNI / TLS passthrough)

Use the `ingress` block to route host-based traffic to the `xray` service port.

Example:

```yaml
service:
  ports:
    - name: xray
      port: 443
      targetPort: 443
      protocol: TCP

ingress:
  enabled: true
  className: nginx
  annotations: # for ingress-nginx
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
  host: www.googletagmanager.com
  servicePort: 443
```

For ingress-nginx passthrough, the controller must run with `--enable-ssl-passthrough`.
Also make sure `ingress.host` matches the XRay "Disguised as traffic from" host (default, `www.googletagmanager.com`).

## Key Values

| Key | Type | Default | Description |
|---|---|---|---|
| `replicaCount` | int | `1` | Number of pod replicas. |
| `image.repository` | string | `ghcr.io/qweritos/paramnezia` | Container image repository. |
| `image.tag` | string | `""` | Image tag, defaults to chart `appVersion` when empty. |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy. |
| `service.type` | string | `LoadBalancer` | Kubernetes service type. |
| `service.ports` | list | `[{name: ssh, port: 22, targetPort: 22, protocol: TCP}]` | Service and container ports for SSH and related protocols. |
| `service.ports[].nodePort` | int | unset | Optional explicit NodePort when `service.type=NodePort`. |
| `ingress.enabled` | bool | `false` | Enable Ingress resource for host-based routing. |
| `ingress.className` | string | `""` | Ingress class name. |
| `ingress.host` | string | `www.googletagmanager.com` | Host matched by Ingress rule. |
| `ingress.servicePort` | int | `443` | Service port used by Ingress backend. |
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

## Help

Feel free to reach out at `me@andrey.wtf` if you need help.
Telegram: [@qweritos](https://t.me/qweritos)
