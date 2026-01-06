output "immich_token_id" {
  value = data.cloudflare_zero_trust_tunnel_cloudflared_token.immich_token.token
}
