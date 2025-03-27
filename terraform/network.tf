# Crear el Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "SSH-allow"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    environment = "casopractico2"
  }

  security_rule {
    name                       = "SSH-allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-allow"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Crear la Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    environment = "casopractico2"
  }
}

# Crear subredes
resource "azurerm_subnet" "mgmt_subnet" {
  name                 = var.subnet_mgmt_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "srv_subnet" {
  name                 = var.subnet_srv_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Crear IP pública para la NIC de servicio (pública dinámica)
resource "azurerm_public_ip" "srv_public_ip" {
  name                = "srv-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags = {
    environment = "casopractico2"
  }
}

# NIC para gestión (IP privada fija)
resource "azurerm_network_interface" "mgmt_nic" {
  name                = "mgmt-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "mgmt-ip"
    subnet_id                     = azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Static" # IP privada fija
    private_ip_address            = "10.0.1.4" # Dirección IP privada fija
  }

  tags = {
    environment = "casopractico2"
  }
}

# NIC para servicios (IP pública dinámica)
resource "azurerm_network_interface" "srv_nic" {
  name                = "srv-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "srv-ip"
    subnet_id                     = azurerm_subnet.srv_subnet.id
    private_ip_address_allocation = "Dynamic" # IP privada dinámica
    public_ip_address_id          = azurerm_public_ip.srv_public_ip.id # Asocia la IP pública
  }

  tags = {
    environment = "casopractico2"
  }
}

# Asociamos el Security Group a la NIC de servicios (srv_nic)
resource "azurerm_network_interface_security_group_association" "srv_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.srv_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
