---
apiVersion: v1alpha1
kind: HostnameConfig
auto: 'off'
hostname: {{ .Node.Host }}
---
apiVersion: v1alpha1
kind: ResolverConfig
nameservers:
  - address: {{ .Data.gatewayIpv4 }}
  - address: {{ .Data.gatewayIpv6 }}
searchDomains:
  domains:
    - {{ .Data.subDomain }}
---
apiVersion: v1alpha1
kind: TimeSyncConfig
ntp:
  servers:
    - {{ .Data.gatewayIpv4 }}
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
  - address: "{{ .Data.networkIpv6 }}{{ .Node.Data.hostSubnetIpv6 }}/{{ .Node.Data.hostSubnetMaskIpv6 }}"
  - address: "{{ .Data.networkIpv4 }}{{ .Node.Data.hostSubnetIpv4 }}/{{ .Node.Data.hostSubnetMaskIpv4 }}"
routes:
  - gateway: "{{ .Data.gatewayIpv6 }}"
    source: "{{ .Data.networkIpv6 }}{{ .Node.Data.hostSubnetIpv6 }}"
  - gateway: "{{ .Data.gatewayIpv4 }}"
    source: "{{ .Data.networkIpv4 }}{{ .Node.Data.hostSubnetIpv4 }}"
---
apiVersion: v1alpha1
kind: KubeNetworkConfig
dnsDomain: cluster.local
podSubnets:
  - fc00::/56
  - 10.244.0.0/16
serviceSubnets:
  - fc00:0:1::/112
  - 10.96.0.0/12
---
