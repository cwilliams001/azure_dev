resource "azurerm_dns_zone" "dev-dns-zone" {
  name                = var.domain_name // Replace with your domain
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "dev-a-record" {
  for_each            = var.ip_addresses
  name                = "${var.record_prefix}-${each.key}" // This will create subdomains like hs-dev-vm-01, hs-dev-vm-02, etc.
  zone_name           = azurerm_dns_zone.dev-dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [each.value] // Replace with one of your VMs, or adjust to use a loop if necessary
}
