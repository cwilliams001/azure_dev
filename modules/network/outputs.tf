output "subnet_id" {
  value       = azurerm_subnet.dev-subnet.id
  description = "The ID of the subnet."
}

output "resource_group_name" {
  value       = azurerm_resource_group.dev-rg.name
  description = "The name of the resource group"
}

output "location" {
  value       = azurerm_resource_group.dev-rg.location
  description = "The location of the resource group"
}