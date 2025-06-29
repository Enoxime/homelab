resource "cloudflare_dns_record" "main_ipv4" {
  name = var.domain
  ttl = 60
  type = "A"
  zone_id = var.zone_id
  content = var.ipv4
  proxied = false
}

resource "cloudflare_dns_record" "main_ipv6" {
  name = var.domain
  ttl = 60
  type = "AAAA"
  zone_id = var.zone_id
  content = var.ipv6
  proxied = false
}

resource "cloudflare_dns_record" "www" {
  name = "www.${var.domain}"
  ttl = 60
  type = "CNAME"
  zone_id = var.zone_id
  content = var.domain
  proxied = false
}

resource "cloudflare_dns_record" "home" {
  name = "home.${var.domain}"
  ttl = 60
  type = "CNAME"
  zone_id = var.zone_id
  content = var.domain
  proxied = false
}
