# The bootstrap server

As mentioned above, the bootstrap server serves as a PXE server, Unifi Network
Application and CA server with ACME. It is the main part of our infrastructure
that manage the creation and maintenance of the infrastructure.

> [!TIP]
> Once the Unifi Network Application is set, we can use the DHCP to help the
> Unifi devices to find where is the controller.
> See [Unifi l3 adoption](https://tcpip.wtf/en/unifi-l3-adoption-with-dhcp-option-43-on-pfsense-mikrotik-and-others.htm)

[](application/ignored)

> [!IMPORTANT]
> Sometimes Unifi devices looks for an Unifi host inside the network.
> I would recommend to set a `unifi.YOURDOMA.IN` to point it to the Unifi
> Network Application.

The OS of choice is [Talos](https://www.siderolabs.com/talos-linux). I choose
Talos because it is immutable, easy to configure and maintain. Everything is
deployed automatically via [fluxcd](https://fluxcd.io/). See
[The kubernetes clusters](./5_the_kubernetes_clusters.md) for more informations.
