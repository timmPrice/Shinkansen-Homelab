terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "1.2.1"
    }
  }
}

provider "incus" {

  generate_client_certificates = true
  accept_remote_certificate    = true
  default_remote               = "kodama-lets"

  remote {
    name     = "kodama-lets"
    address  = var.incus_address
    token    = var.incus_token
    protocol = "incus"
  }
}

resource "incus_instance" "wrt-hydrogen" {
  name  = "wrt-hydrogen"
  image = "images:openwrt/25.12"
  type  = "virtual-machine"

  device {
    name = "lan"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = var.lan_bridge
    }
  }

  device {
    name = "wan"
    type = "nic"

    properties = {
      nictype = "physical"
      parent  = var.wan_interface
    }
  }
}

