locals {
  vm_name = "${var.name_prefix}-vm"
}

resource "azurerm_linux_virtual_machine" "web" {
  name                = local.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  computer_name       = local.vm_name
  network_interface_ids = [
    azurerm_network_interface.web.id,
  ]
  disable_password_authentication = true
  provision_vm_agent              = true
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
