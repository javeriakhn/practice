provider "azurerm" {
  features {}
}

data "azurerm_client_config" "example" {}

resource "azurerm_container_registry" "source_acr" {
  name                = "sourceacr"
  resource_group_name = "source-rg"
  location            = "West Europe"
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_registry" "instance_acr" {
  name                = var.acr_server
  resource_group_name = "instance-rg"
  location            = "West Europe"
  sku                 = "Basic"
  admin_enabled       = true
}

resource "null_resource" "import_charts" {
  count = length(var.charts)

  provisioner "local-exec" {
    command = <<EOT
      az acr import --name ${azurerm_container_registry.instance_acr.name} \
                    --source ${var.source_acr_server}/${element(var.charts, count.index).chart_repository}:${element(var.charts, count.index).chart_version} \
                    --username ${var.source_acr_client_id} \
                    --password ${var.source_acr_client_secret}
    EOT
  }
}

resource "helm_release" "chart_release" {
  count = length(var.charts)

  name       = element(var.charts, count.index).chart_name
  namespace  = element(var.charts, count.index).chart_namespace
  repository = "${azurerm_container_registry.instance_acr.login_server}/${element(var.charts, count.index).chart_repository}"
  chart      = element(var.charts, count.index).chart_name
  version    = element(var.charts, count.index).chart_version
  values     = [for v in element(var.charts, count.index).values : "${v.name}=${v.value}"]
}

