provider "azurerm" {
features {}
subscription_id = "ece4380e-abf1-4393-b928-7183ca7d5480"
}

resource "azurerm_resource_group" "rg" {
name     = "codecraft-rg"
location = "East US"
}

resource "azurerm_container_registry" "acr" {
name                = "codecraftacr11561223"
resource_group_name = azurerm_resource_group.rg.name
location            = azurerm_resource_group.rg.location
sku                 = "Basic"
admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
name                = "codecraft-aks"
location            = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
dns_prefix          = "codecraftaks"

default_node_pool {
name       = "default"
node_count = 1
vm_size    = "Standard_DS2_v2"
}

identity {
type = "SystemAssigned"
}

role_based_access_control {
enabled = true
}

network_profile {
network_plugin = "azure"
}
}

resource "azurerm_role_assignment" "acr_pull" {
principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
role_definition_name = "AcrPull"
scope                = azurerm_container_registry.acr.id
}
