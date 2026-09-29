---
apiVersion: v1alpha1
kind: KubeletConfig
extraArgs:
  rotate-server-certificates: true
---
{{- if and (eq .Node.Data.cpuType "amd") (eq .Node.Data.hostSubnetIpv4 123) }}
---
machine:
  sysctls:
    net.core.bpf_jit_harden: 1
---
apiVersion: v1alpha1
kind: KernelModuleConfig
name: nvidia
---
apiVersion: v1alpha1
kind: KernelModuleConfig
name: nvidia_uvm
---
apiVersion: v1alpha1
kind: KernelModuleConfig
name: nvidia_drm
---
apiVersion: v1alpha1
kind: KernelModuleConfig
name: nvidia_modeset
---
{{- end }}
