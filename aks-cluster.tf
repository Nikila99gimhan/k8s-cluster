resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.aks_service_principal_client_id
    client_secret = var.aks_service_principal_client_secret
  }

  tags = {
    environment = "Production"
  }
}

resource "local_file" "kubeconfig" {
  filename   = "./.kube/config"
  content    = azurerm_kubernetes_cluster.default.kube_config_raw
  depends_on = [azurerm_kubernetes_cluster.default]
}

resource "helm_release" "traefik" {
  namespace        = "traefik"
  create_namespace = true
  name             = "traefik"
  repository       = "https://helm.traefik.io/traefik"
  chart            = "traefik"
  depends_on       = [local_file.kubeconfig]
}
