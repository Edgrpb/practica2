variable "location" {
  description = "Ubicación de los recursos en Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "acr_name" {
  description = "Nombre del Azure Container Registry"
  type        = string
}


variable "aks_name" {
  description = "Nombre del clúster AKS"
  type        = string
}

variable "aks_size" {
  type        = string
  description = "Tamaño de la máquina virtual"
  default     = "Standard_D2_v2" 
}

variable "dns_prefix" {
  description = "El prefijo DNS para el clúster de Kubernetes"
  type        = string
}

variable "vm_name" {
  description = "Nombre de la máquina virtual"
  type        = string
}

variable "vm_size" {
  type        = string
  description = "Tamaño de la máquina virtual"
}


variable "vm_username" {
  description = "usuario"
  type        = string
}

variable "vnet_name" {
  description = "Nombre de la subred de gestión"
  type        = string
}

variable "subnet_mgmt_name" {
  description = "Nombre de la subred de gestión"
  type        = string
}

variable "subnet_srv_name" {
  description = "Nombre de la subred de servicios"
  type        = string
}
