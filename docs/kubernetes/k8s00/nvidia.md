# nvidia

## Test nvidia

```bash
kubectl run nvidia-test \
  --restart=Never \
  -ti \
  --rm \
  --namespace nvidia-gpu \
  --image nvcr.io/nvidia/cuda:12.5.0-base-ubuntu22.04 \
  --overrides \
    '{"spec": {"runtimeClassName": "nvidia", "nodeName": "<WORKER_NAME>"}}' \
    nvidia-smi
```
