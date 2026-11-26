---
cluster:
  etcd:
    advertisedSubnets:
      - "{{ .Data.networkIpv6 }}/64"
---
