resource "azurerm_container_registry" "acr" {
  name                = "scholarxlms"
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}