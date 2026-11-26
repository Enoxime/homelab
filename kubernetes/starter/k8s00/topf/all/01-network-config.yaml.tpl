---
apiVersion: v1alpha1
kind: HostnameConfig
auto: 'off'
hostname: {{ .Node.Host }}.{{ .Data.subDomain }}
---
apiVersion: v1alpha1
kind: ResolverConfig
nameservers:
  - address: {{ .Data.networkIpv6 }}53
searchDomains:
  domains:
    - {{ .Data.subDomain }}
---
apiVersion: v1alpha1
kind: TimeSyncConfig
ntp:
  servers:
    - {{ .Data.gatewayIpv6 }}
---
apiVersion: v1alpha1
kind: BridgeConfig
name: br0
links:
  - "{{ .Node.Data.interfaceName }}"
stp:
  enabled: true
up: true
addresses:
  - address: "{{ .Data.networkIpv6 }}{{ .Node.Data.subnet }}/128"
routes:
  - gateway: "{{ .Data.networkIpv6 }}1"
    destination: "{{ .Data.networkIpv6 }}/64"
---
apiVersion: v1alpha1
kind: KubeNetworkConfig
dnsDomain: cluster.local
podSubnets:
  - fc00::/56
serviceSubnets:
  - fc00:0:1::/112
---
apiVersion: v1alpha1
kind: KubeNodeConfig
nodeIP:
  validSubnets:
    - "{{ .Data.networkIpv6 }}/64"
---
