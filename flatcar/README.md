# Flatcar delivery

1. Transform a butane file to an ignition file

    ```bash
    podman run \
      --interactive \
      --rm quay.io/coreos/butane:release \
        --pretty \
        --strict < flatcar.butane.yaml > flatcar.ignition.json
    ```

2. Run locally a server to serve the ignition file

    ```bash
    sudo podman run \
      -it \
      --rm \
      --name deploy_flatcar \
      -v ./:/usr/share/nginx/html:ro \
      -p 80:80 \
      docker.io/nginx
    ```

3. Download the ignition file in the instance

    ```bash
    curl <IP>/flatcar.ignition.json -o /tmp/flatcar.ignition.json
    ```

4. Install flatcar

    ```bash
    flatcar-install -d /dev/<DISK> -C stable -i /tmp/flatcar.ignition.json

    reboot
    ```
