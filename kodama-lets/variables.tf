variable "incus_address" {
  description = "url for incus API on kodama-lets"
  type        = string
  sensitive   = false
  # http://kodama-lets:8443 -- will require tailscale
}

variable "incus_token" {
  description = "one-time trust token from `incus token trust add`"
  type        = string
  sensitive   = true
}
