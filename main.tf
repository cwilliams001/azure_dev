terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment_tag     = var.environment_tag
}

module "vm" {
  source              = "./modules/vm"
  vm_count            = var.vm_count
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  ssh_public_key_path = var.ssh_public_key_path
  subnet_id           = module.network.subnet_id
  environment_tag     = var.environment_tag
}

module "dns" {
  source              = "./modules/dns"
  record_prefix       = var.record_prefix
  resource_group_name = module.network.resource_group_name
  domain_name         = var.domain_name
  ip_addresses        = module.vm.public_ips
  location            = module.network.location
  environment_tag     = var.environment_tag
}

output "public_ips" {
  value       = module.vm.public_ips
  description = "The public IP addresses of the VMs"
}

output "dns_zone_info" {
  value       = module.dns.dns_zone_info
  description = "The name and name servers of the DNS zone"
}
