resource "cloudflare_zero_trust_tunnel_cloudflared" "immich" {
  account_id = var.account_id
  name = "immich"
  config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "immich_token" {
  account_id = var.account_id
  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.immich.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "immich_tunnel_config" {
  account_id = var.account_id
  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.immich.id
  config = {
    ingress = [ {
      hostname = "photos.${var.domain}"
      service = "http://immich-public-proxy:3000"
      path = "/share"
    },
    {
      hostname = "photos.${var.domain}"
      service = "http://immich-server:2283"
    },
    {
      service  = "http_status:404"
    } ]
  }
}
