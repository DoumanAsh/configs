terraform {
  required_providers {
    openobserve = {
      source  = "openobserve/openobserve"
      version = "~> 1.3"
    }
  }
}

provider "openobserve" {
  endpoint = "https://roseline.servebeer.com/_observe/"
  username = var.openobserve_username
  password = var.openobserve_password

  # Used by every resource that does not set org_id itself.
  org_id = "default"
}
