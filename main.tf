locals {
  dns_records = merge([
    for domain, records in var.domains : {
      for record_name, record in records.records :
      "${record_name}_in_${domain}" => {
        zone_id  = cloudflare_zone.zones[domain].id
        name     = record.name
        value    = record.value
        type     = record.type
        ttl      = record.ttl
        proxied  = record.proxied
        comment  = "${record.comment}: ${record_name}"
        priority = record.priority
      }
    }
  ]...)
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_zone" "zones" {
  for_each = var.domains

  account_id = var.account_id
  zone       = each.key
}

resource "cloudflare_record" "dns_records" {
  for_each = local.dns_records

  zone_id         = each.value.zone_id
  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
  ttl             = each.value.ttl
  proxied         = each.value.proxied
  comment         = each.value.comment
  priority        = each.value.priority
  allow_overwrite = true
}
