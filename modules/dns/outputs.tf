output "dns_zone_info" {
  value = {
    name         = azurerm_dns_zone.dev-dns-zone.name
    name_servers = azurerm_dns_zone.dev-dns-zone.name_servers
  }
  description = "The name and name servers of the DNS zone"
}

output "full_domain_names" {
  value = { for key, value in azurerm_dns_a_record.dev-a-record : key => format("%s.%s", value.name, azurerm_dns_zone.dev-dns-zone.name) }
  description = "The full domain names of the VMs."
}