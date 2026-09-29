customization:
  systemExtensions:
    officialExtensions:
      {{- if eq .Node.Data.cpuType "intel" }}
      - siderolabs/i915
      - siderolabs/intel-ucode
      {{- end }}
      {{- if eq .Node.Data.cpuType "amd" }}
      - siderolabs/amdgpu
      - siderolabs/amd-ucode
      {{- end }}
