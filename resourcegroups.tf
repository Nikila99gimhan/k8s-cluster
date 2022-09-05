resource "azurerm_resource_group" "default" {
  name     = "aks-cluster-rg"
  location = var.location

  tags = {
    environment = "Production"
  }
}