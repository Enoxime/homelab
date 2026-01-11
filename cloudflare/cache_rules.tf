resource "cloudflare_ruleset" "photos_immich" {
  kind = "zone"
  name = "No caching on /share/video for immich"
  phase = "http_request_cache_settings"
  account_id = var.account_id
  description = "Bypass caching on /share/video for immich. See https://community.cloudflare.com/t/mp4-wont-load-in-safari-using-cloudflare/10587/48"
  zone_id = var.zone_id
  rules = [ {
    action = "set_cache_settings"
    expression = "(http.host eq \"photos.${var.domain}\" and starts_with(http.request.uri.path, \"/share/video\"))"
    description = "Bypass caching on hostname photos.${var.domain} that starts with path /share/video"
    enabled = true
    action_parameters = {
      cache = false
    }
  } ]
}
