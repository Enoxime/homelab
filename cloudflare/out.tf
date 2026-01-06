output "immich_tunnel_token" {
  value = data.cloudflare_zero_trust_tunnel_cloudflared_token.immich_token.token
}
