
# OPNsense automatic certificate

## Bind

Bind will be used to point ACME requests to the router.

In OPNsense got to `Services -> Bind -> Configuration`.

1. Check "Enable BIND Daemon".
2. Listen IPs `0.0.0.0`.
3. Because the router already have a dns server using port 53, the listen port
of this one should be different. In this case it will be `53530`.
4. Save.

Then go to `Primary Zones` and add a zone.

1. Set the zone name as the local domain name like `internal.example.com`.
2. Set the `TTL`, `Refresh Time`, `Retry Time`, `Expire Time` and `Negative TTL`
as you wish.
3. Set the `DNS Server` to the default one on your router. It should be
something like 192.168.0.1 or something like router.example.com if you set up
the router domain name.
4. Save.

Then add records. The first record is a nameserver record and the second one is
the IP of the nameserver.

1. Select the `Zone` we created previously.
2. `Name` should be `@`.
3. The `Type` is `NS`.
4. The `Value` is the local domain name like `internal.example.com`.
5. Save and create another record.
6. Select the `Zone` we created previously.
7. `Name` should be `@`.
8. The `Type` is `A`.
9. The `Value` is the router default IP like `192.168.0.1`.
10. Save.

## ACME

ACME is the system that will request a new certificate and configure Bind to
add an entry to confirm the origin of the domain name requested. To be able to
do so, ACME will need some permission to request changes to Bind.

Go to `System -> Access -> Users`.

1. Find your user and select the icon that create an API key.
2. Save those data somewhere safe.

Go to `Services -> ACME Client -> Settings` and enable the plugin. Then go to
`Services -> ACME Client -> Account` and add an account.

1. `Name` is the name of the account. It could be whatever you want.
2. `Description` is the same. But put something meaningful.
3. `E-Mail Address` is you email.
4. `ACME CA` chose `Custom CA URL`.
5. `Custom CA URL` insert the domain name of your CA server with the ACME
directory like `https://ca.internal.example.com/acme/acme/directory`.
6. Save.

Go to `Services -> ACME Client -> Challenge Types` and add a challenge.

1. Insert something in `Name` and `Description`.
2. `Challenge Type` chose `DNS-01`.
3. `DNS Service` chose `BIND Plugin`.
4. `OPNSense Server (FQDN)` insert `localhost`.
5. `OPNSense Server Port` insert the port you use to reach the web UI. Usually
it is `8443`.
6. `User API key` insert the API key you saved previously.
7. `User API token` insert the token you saved previously.
8. Check `Disable TLS Verification`.
9. Save.

Go to `Services -> ACME Client -> Automations` and add an automation.

1. Insert a `Name` and `Description`.
2. In `Run Command` chose `Restart OPNsense Web UI`.
3. Save.

And for last, go to `Services -> ACME Client -> Certificates` and add a
certificate.

1. `Common Name` should be the router domain name.
2. `Description` describe the certificate intention.
3. `ACME Account` chose your account.
4. `Challenge Type` chose the challenge created previously.
5. Check `Auto Renewal`.
6. `Renewal Interval` could be one day.
7. `Key Length` chose a key length. Could be `ec-384`.
8. `Automations` chose the automation created previously.
9. Save.

Done. The certificate will be automatically renewed. To ensure it works, it can
be activated now by clicking the `Run Automation` icon.
