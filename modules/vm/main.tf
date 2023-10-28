locals {
  vm_names = toset(formatlist("${var.vm_name_prefix}-%02d", range(1, var.vm_count + 1)))
}


resource "azurerm_public_ip" "dev-pip" {
  for_each = local.vm_names

  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_interface" "dev-nic" {
  for_each = local.vm_names

  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.key}-nic-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev-pip[each.key].id
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_linux_virtual_machine" "dev-vm" {
  for_each = local.vm_names

  name                  = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.dev-nic[each.key].id]
  size                  = "Standard_B1s"
  admin_username        = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
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
    environment = var.environment_tag
  }

}
