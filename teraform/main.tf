provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = var.network_plugin
  }

  tags = jsondecode(var.tags)
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "helm_release" "ping" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name       = var.chart_name
  repository = "oci://${azurerm_container_registry.acr.login_server}/helm-charts"
  chart      = var.chart_name
  namespace  = var.chart_namespace
  version    = var.chart_version

  values = [
    for value in var.values : {
      name  = value.name
      value = value.value
    }
  ]

  set_sensitive = [
    for sensitive_value in var.sensitive_values : {
      name  = sensitive_value.name
      value = sensitive_value.value
    }
  ]
}


