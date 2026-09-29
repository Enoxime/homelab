---
cluster:
  etcd:
    advertisedSubnets:
      - "{{ .Data.networkIpv4 }}0/24"
      - "{{ .Data.networkIpv6 }}/64"
---
