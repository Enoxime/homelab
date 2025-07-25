terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 5.6.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cf_api_token
}
