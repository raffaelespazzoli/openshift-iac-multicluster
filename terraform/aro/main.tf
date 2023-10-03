
data "azurerm_client_config" "current" {
}

locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/aro-${var.name}"
}

resource "random_string" "resource_prefix" {
  length  = 6
  special = false
  upper   = false
  numeric  = false
}

resource "random_string" "domain" {
  length  = 8
  special = false
  upper   = false
  numeric  = false
}

data "azurerm_resource_group" "resource_group" {
  name                = var.resource_group_name
}

resource "azapi_resource" "aro_cluster" {
  name      = var.name
  location  = var.location
  parent_id = data.azurerm_resource_group.resource_group.id
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2022-04-01"
  tags      = var.tags

  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = "${var.domain != "" ? var.domain : random_string.domain.result}"
        fipsValidatedModules = var.fips_validated_modules
        resourceGroupId      = local.resource_group_id
        pullSecret           = var.pullSecret
      }
      networkProfile = {
        podCidr              = var.pod_cidr
        serviceCidr          = var.service_cidr
      }
      servicePrincipalProfile = {
        clientId             = var.spClientId
        clientSecret         = var.spClientSecret
      }
      masterProfile = {
        vmSize               = var.master_node_vm_size
        subnetId             = var.master_subnet_id
        encryptionAtHost     = var.master_encryption_at_host
      }
      workerProfiles = [
        {
          name               = var.worker_profile_name
          vmSize             = var.worker_node_vm_size
          diskSizeGB         = var.worker_node_vm_disk_size
          subnetId           = var.worker_subnet_id
          count              = var.worker_node_count
          encryptionAtHost   = var.worker_encryption_at_host
        }
      ]
      apiserverProfile = {
        visibility           = var.api_server_visibility
      }
      ingressProfiles = [
        {
          name               = var.ingress_profile_name
          visibility         = var.ingress_visibility
        }
      ]
    }
  })

  response_export_values = ["properties.apiserverProfile.url", "properties.consoleProfile.url"]

  lifecycle {
    ignore_changes = [
        tags,
        body,
        response_export_values
    ]
  }

  timeouts {
    create = "90m"
    update = "30m"
    delete = "60m"
  }
}

resource "azapi_resource_action" "kubeconfig" {
  type = "Microsoft.RedHatOpenShift/openShiftClusters@2023-07-01-preview"
  resource_id = azapi_resource.aro_cluster.id
  action      = "listAdminCredentials"
  method      = "POST"  
  response_export_values = ["*"]

  depends_on = [ azapi_resource.aro_cluster ]
}

resource "azapi_resource_action" "admin_credentials" {
  type = "Microsoft.RedHatOpenShift/openShiftClusters@2023-07-01-preview"
  resource_id = azapi_resource.aro_cluster.id
  action      = "listCredentials"
  method      = "POST"  
  response_export_values = ["*"]

  depends_on = [ azapi_resource.aro_cluster ]
}