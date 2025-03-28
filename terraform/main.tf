terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Crear el grupo de recursos principal
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

 tags = {
    environment = "practica2"
  }
}
