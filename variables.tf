variable "api_token" {
  description = "CloudFlare api_token. Check Profile page to find."
  type        = string
}

variable "account_id" {
  description = "CloudFlare account_id. Check zone Overview page to find."
  type        = string
}

variable "domains" {
  description = "Map of domains with their DNS records"
  type = map(object({
    records = map(object({
      name     = string
      value    = string
      type     = string
      ttl      = optional(number, 1)
      proxied  = optional(bool, false)
      comment  = optional(string, "Managed by terraform")
      priority = optional(number, 0)
    }))
  }))
  default = {}
}
