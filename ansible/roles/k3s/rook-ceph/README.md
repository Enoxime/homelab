# rook-ceph, ansible role for kubernetes

This role deploy a ceph cluster in your kubernetes cluster and provide a storage class.

Configuration:
```yaml
k3s:
  config:
    rook:
      ceph:
        version: "ceph/ceph:v15.2.13" # Used and tested version
        use_all_nodes: bool # This option specify if you wan to use a default setup to search in all nodes for available disks to include in the ceph cluster
        nodes: # This option is to use when you set use_all_nodes to no.
          - name: "" # Name of the node to search for specific disks
            devices: # Devices to include
              - name: "/dev/disk/by-id/DISK_ID" # It is recommended to use the disk by id path as it is less subject to errors and the path name should not change.
```