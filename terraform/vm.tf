# Crear la VM Linux
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_username
  tags = {
    environment = "casopractico2"
  }

  # Asociamos las NICs, poniendo primero la de servicios (srv_nic)
  network_interface_ids = [
    azurerm_network_interface.srv_nic.id,  
    azurerm_network_interface.mgmt_nic.id,
  ]

  # Llave SSH para acceso seguro
  admin_ssh_key {
    username   = var.vm_username  
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro"
    version   = "latest"
  }
}

# Genera la clave SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Guarda el archivo de la clave privada en local
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/vm-practica2_key.pem"
}
