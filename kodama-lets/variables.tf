variable "incus_address" {
  description = "url for incus API on kodama-lets"
  type        = string
  sensitive   = false
  # https://kodama-lets:8443 -- will require tailscale
}

variable "incus_token" {
  description = "one-time trust token from `incus token trust add <name>`"
  type        = string
  sensitive   = true
}

variable "lan_bridge" {
  description = "network bridge for the lan connector on openwrt, should be connected to a usb-c nic"
  type        = string
  sensitive   = false
}

variable "wan_interface" {
  description = "default eth0 interface on the kodama-lets device"
  type        = string
  sensitive   = false
}
