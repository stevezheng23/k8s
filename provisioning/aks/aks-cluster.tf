resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "xiaoming-${random_pet.prefix.id}-rg"
  location = "West US 2"

  tags = {
    environment = "xiaoming-dev"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "xiaoming-${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "xiaoming-${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D4s_v3"
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "xiaoming-dev"
  }
}
