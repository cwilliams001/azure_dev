terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "dev-rg" {
  name     = "dev-rg"
  location = "East Us"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "dev-vnet" {
  name                = "dev-vnet"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = azurerm_resource_group.dev-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "dev-subnet" {
  name                 = "dev-subnet"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.dev-vnet.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "dev-nsg" {
  name                = "dev-nsg"
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    environment = "dev"
  }

}

resource "azurerm_network_security_rule" "dev-rule" {
  name                        = "dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dev-rg.name
  network_security_group_name = azurerm_network_security_group.dev-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "dev-sga" {
  subnet_id                 = azurerm_subnet.dev-subnet.id
  network_security_group_id = azurerm_network_security_group.dev-nsg.id
}

locals {
  vm_count = 3 # Adjust this number to create more VMs
  vm_names = toset(formatlist("dev-vm-%02d", range(1, local.vm_count + 1)))
}

resource "azurerm_public_ip" "dev-pip" {
  for_each = local.vm_names

  name                = "${each.key}-pip"
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "dev-nic" {
  for_each = local.vm_names

  name                = "${each.key}-nic"
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "${each.key}-nic-ip"
    subnet_id                     = azurerm_subnet.dev-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev-pip[each.key].id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "dev-vm" {
  for_each = local.vm_names

  name                  = each.key
  location              = azurerm_resource_group.dev-rg.location
  resource_group_name   = azurerm_resource_group.dev-rg.name
  network_interface_ids = [azurerm_network_interface.dev-nic[each.key].id]
  size                  = "Standard_B1s"
  admin_username        = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/dev-azure.pub")
  }

  os_disk {
    name                 = "${each.key}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }

}

output "public_ips" {
  value = { for name, pip in azurerm_public_ip.dev-pip : name => pip.ip_address }
  description = "The public IP addresses of the VMs"
}
