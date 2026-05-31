# The CA server

OK now it is finally starting to get interesting. I went with the following
tutorial on this one
[Build a Tiny Certificate Authority For Your Homelab](https://smallstep.com/blog/build-a-tiny-ca-with-raspberry-pi-yubikey/)
and did all the optional parts because it is cool. I choose to go with
[dietpi](https://dietpi.com/) as the OS.

After testing against the tutorial I went with the "automate everything" way and
write Ansible roles to do it for me in case of needed changes or just redoing it
entirely (See the Ansible folder).

> [!IMPORTANT]
> I will not go on explaining all the steps needed to be done because I assume
> that you know the basics with Ansible. *I also assume that you store your
> private variables encrypted somewhere else with a strong password.*

- CA server the Ansible way:
  - [Set up the SD card](#ca-server-the-ansible-way-set-up-the-sd-card)
  - [Ensure the server is up to standard](#ca-server-the-ansible-way-ensure-the-server-is-up-to-standard)
  - [Set up and configure our CA server](#ca-server-the-ansible-way-set-up-and-configure-our-ca-server)
  - [Testing](#ca-server-the-ansible-way-testing)
- [Bonus: get its own certificate](#bonus-get-its-own-certificate)
  - [Bind](#bind)
  - [Unbound DNS](#unbound-dns)
  - [ACME](#acme)

## CA server the Ansible way: Set up the SD card

To be able to boot headless, we will need to insert the SD card on the
personal computer and run the playbook
[prepare_infra.yaml](../../ansible/prepare_infra.yaml).

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --limit ca \
  --inventory hosts.yaml \
  --ask-become-pass \
  --extra-vars ansible_user=$(whoami) \
  prepare_infra.yaml

# Then we add our user manager
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --limit ca \
  --inventory hosts.yaml \
  --private-key PRIV_SSH_KEY_PATH \
  --extra-vars ansible_host=HOST_IP \
  prepare_infra.yaml
```

## CA server the Ansible way: Ensure the server is up to standard

Now that the server is up, we need to ensure the server respect our policies. To
do so, we will need simply to run
[standardization.yaml](../../ansible/standardization.yaml).

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --limit ca \
  --inventory hosts.yaml \
  standardization.yaml
```

## CA server the Ansible way: Set up and configure our CA server

All the boring stuff is done, now it is the good and fun part. We will set up a
CA server with a USB noise maker, a basic USB and a set of yubikeys!

Check the
[documentation on the role](../../ansible/roles/certificate-authority-server/README.md)
about how to set up the configuration. Run [setup.yaml](../../ansible/setup.yaml).

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --limit ca \
  --inventory hosts.yaml \
  setup.yaml
```

## CA server the Ansible way: Testing

The server is up and running, we just need to play with it to ensure it works as
expected. We can first get the root CA via the URL by doing a `curl --insecure
https://YOUR_CA_SERVER_HOSTNAME/roots.pem`. We can also install Cerbot locally
and try to obtain a certificate. We can set up the Opnsense router to ask for a
[certificate](https://homenetworkguy.com/how-to/replace-opnsense-web-ui-self-signed-certificate-with-lets-encrypt/).

> [!NOTE]
> We will need to set up a local Bind server to answer the step-ca call for
> internal domain.

## Bonus: get its own certificate

Now that the CA server is up and running, it would be a nice idea to set up the
router with a certificate. For that, there will be a need to configure Bind and
ACME.

### OPNsense automatic certificate

#### Bind

Bind will be used to point ACME requests to the router.

In OPNsense go to `Services -> Bind -> Configuration`.

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

#### Unbound DNS

As Unbound DNS is used as the main server, it will need to know where to look at
for the DNS challenge on Bind.

In OPNsense go to `Services -> Unbound DNS -> Query Forwarding`.

1. Click on the plus `+` sign to add the query forward entry.
2. Set the `Domain` to `internal.example.com`.
3. Set the `Server IP` to `127.0.0.1`.
4. Set the `Server Port` to `53530`.
5. Don't check the `Forward first`.
6. Add a description.
7. Save.

#### ACME

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
