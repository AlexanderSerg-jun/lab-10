terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }

    #proxmox = {
    #  source = "Telmate/proxmox"
    #  version = "2.9.14"
    #}
    proxmox = {
      source  = "thegameprofi/proxmox"
      version = ">= 2.9.15"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true
}