resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = var.aks_size
  }

  identity {
    type = "SystemAssigned"
  }

 
  tags = {
    environment = "practica2"
  }

 
}

resource "azurerm_role_assignment" "ra-perm" {
  principal_id          = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name  = "AcrPull"
  scope                 = azurerm_container_registry.acr.id
}