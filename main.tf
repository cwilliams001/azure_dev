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

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/playbooks/templates/hosts.ini.tpl", { ips = module.vm.public_ips })
  filename = "${path.module}/playbooks/hosts.ini"
}

resource "local_file" "ansible_vars" {
  for_each = module.dns.full_domain_names

  content = templatefile("${path.module}/playbooks/templates/main.yml.tpl", {
    server_url               = format("https://%s:443", each.value)
    tls_letsencrypt_hostname = each.value
    acme_email               = var.acme_email
    base_domain              = module.dns.dns_zone_info.name
  })
  filename = "${path.module}/playbooks/headscale/vars/${each.key}_main.yml"
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
  vm_name_prefix      = var.vm_name_prefix
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  admin_username      = var.admin_username
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

output "vm_full_domain_names" {
  value       = module.dns.full_domain_names
  description = "The full domain names of the VMs."
}


