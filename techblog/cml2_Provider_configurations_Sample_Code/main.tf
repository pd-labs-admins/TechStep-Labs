terraform {
  required_providers {
    cml2 = {
      source  = "CiscoDevNet/cml2"
      version = "0.9.3-beta1"
    }
  }
}

variable "cml_address" {
  type = string
}

variable "cml_username" {
  type = string
}

variable "cml_password" {
  type = string
}

provider "cml2" {
  address     = var.cml_address
  username    = var.cml_username
  password    = var.cml_password
  skip_verify = true

  # named configs was introduced w/ 0.8.0 and CML 2.7.0, the default is false
  # enable this to provide multiple day0 configurations, the Cat 9000v is a
  # device that supports this to provide a unique serial number per device.
  named_configs = true
}

resource "cml2_lab" "lab" {
  title       = "Sample_Lab"
  description = "For Testing"
}

resource "cml2_node" "ubuntu01" {
  lab_id         = cml2_lab.lab.id
  label          = "ubuntu01"
  nodedefinition = "ubuntu"
  configurations = [
    {
      name    = "user-data"
      content = file("configs/ubuntu01_user-data.txt")
    },
    {
      name    = "network-config"
      content = file("configs/ubuntu01_network-config.txt")
    }
  ]
  x    = 0
  y    = 0
}

