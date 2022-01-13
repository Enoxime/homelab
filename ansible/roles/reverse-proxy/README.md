# Reverse-proxy role

This role setup a reverse-proxy server in an instance.

## Features

- Automatic setup with Letsencrypt
- Can add your own certificate to the setup
- Can create an upstream list of servers
- can use TCP and UDP services
- Automatic https redirection

## Configuration
The following tables describe each options and categories.

### Nginx miscelanous

Parameter                 | Description                                                     | Default
--------------------------|-----------------------------------------------------------------|-------------------------------
`nginx.dns_resolver`      | IP address of dns servers to resolve internal or external name  | `[""]`
`nginx.internal_network`  | Range of internal networks that can be used as network filter   | `[ name: "", ip_range: [""] ]`

### Nginx config

`nginx.config`

Parameter                 | Description                                                                                                       | Default
--------------------------|-------------------------------------------------------------------------------------------------------------------|------------------------------
`user`                    | Unix username or ID to run the nginx server                                                                       | `"www-data"`
`cerbot.email`            | This email is used for letsencrypt during requesting of certificates. Activate the letsencrypt part when filled.  | `""`
`http.ssl_protocols`      | Choose which protocols that the reverse-proxy should support                                                      | `["TLSv1.2", "TLSv1.3"]`
`http.ssl_ciphers`        | List of ciphers used by the chosen protocols that you desire to use. <br>You should note the if you choose only `"TLSv1.3"` you will wish to use those three protocols:<br><br><pre>[<br>  "TLS-AES128-GCM-SHA256",<br>  "TLS-AES256-GCM-SHA384",<br>  "TLS-CHACHA20-POLY1305-SHA256"<br>]</pre> | <pre>[<br>  "ECDHE-ECDSA-AES128-GCM-SHA256",<br>  "ECDHE-RSA-AES128-GCM-SHA256",<br>  "ECDHE-ECDSA-AES256-GCM-SHA384",<br>  "ECDHE-RSA-AES256-GCM-SHA384",<br>  "ECDHE-ECDSA-CHACHA20-POLY1305",<br>  "ECDHE-RSA-CHACHA20-POLY1305",<br>  "DHE-RSA-AES128-GCM-SHA256",<br>  "DHE-RSA-AES256-GCM-SHA384"<br>]</pre>
`http.cache.path`         | Absolute path for the cache                                                                                       | `""`
`http.cache.name`         | Shared memory zone name                                                                                           | `""`
`http.cache.size`         | Max size of the cache                                                                                             | `""`
`http.geo[].name`         |
`http.geo[].addresses`    |