---
apiVersion: v1alpha1
kind: DiscoveryServiceConfig
name: default
$patch: delete
---
apiVersion: v1alpha1
kind: DiscoveryIdentityConfig
$patch: delete
---
apiVersion: v1alpha1
kind: KubeFlannelCNIConfig
$patch: delete
---
apiVersion: v1alpha1
kind: KubeProxyConfig
enabled: false
---
