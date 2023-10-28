output "dns_zone_info" {
  value = {
    name         = azurerm_dns_zone.dev-dns-zone.name
    name_servers = azurerm_dns_zone.dev-dns-zone.name_servers
  }
  description = "The name and name servers of the DNS zone"
}
