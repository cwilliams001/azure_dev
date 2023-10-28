output "public_ips" {
  value       = { for name, pip in azurerm_public_ip.dev-pip : name => pip.ip_address }
  description = "The public IP addresses of the VMs"
}
