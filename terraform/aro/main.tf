terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.3.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}

data "azurerm_client_config" "current" {
}

locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/aro-${var.domain}-${var.location}"
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
  numeric  = true
}

# resource "azurerm_virtual_network" "virtual_network" {
#   name                = "${var.resource_prefix != "" ? var.resource_prefix : random_string.resource_prefix.result}VNet"
#   address_space       = var.virtual_network_address_space
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags
  
#   lifecycle {
#     ignore_changes = [
#         tags
#     ]
#   }
# }

# resource "azurerm_subnet" "master_subnet" {
#   name                                           = var.master_subnet_name
#   resource_group_name                            = var.resource_group_name
#   virtual_network_name                           = azurerm_virtual_network.virtual_network.name
#   address_prefixes                               = var.master_subnet_address_space
#   private_link_service_network_policies_enabled  = false
#   service_endpoints                              = ["Microsoft.ContainerRegistry"]
# }

# resource "azurerm_subnet" "worker_subnet" {
#   name                                           = var.worker_subnet_name
#   resource_group_name                            = var.resource_group_name
#   virtual_network_name                           = azurerm_virtual_network.virtual_network.name
#   address_prefixes                               = var.worker_subnet_address_space
#   service_endpoints                              = ["Microsoft.ContainerRegistry"]
# }

# resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor" {
#   scope                = azurerm_virtual_network.virtual_network.id
#   role_definition_name = "Contributor"
#   principal_id         = var.aro_cluster_aad_sp_object_id
#   skip_service_principal_aad_check = true
# }

# resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
#   scope                = azurerm_virtual_network.virtual_network.id
#   role_definition_name = "Contributor"
#   principal_id         = var.aro_rp_aad_sp_object_id
#   skip_service_principal_aad_check = true
# }

data "azurerm_resource_group" "resource_group" {
  name                = var.resource_group_name
}

data "azurerm_subnet" "master_subnet" {
  name                = var.master_subnet_name
}

data "azurerm_subnet" "worker_subnet" {
  name                = var.master_subnet_name
}

resource "azapi_resource" "aro_cluster" {
  name      = "${var.resource_prefix != "" ? var.resource_prefix : random_string.resource_prefix.result}Aro"
  location  = var.location
  parent_id = data.azurerm_resource_group.resource_group.id
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2022-04-01"
  #tags      = var.tags
  
  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = "${var.domain != "" ? var.domain : random_string.domain.result}"
        fipsValidatedModules = var.fips_validated_modules
        resourceGroupId      = local.resource_group_id
        pullSecret           = var.pull_secret
      }
      networkProfile = {
        podCidr              = var.pod_cidr
        serviceCidr          = var.service_cidr
      }
      servicePrincipalProfile = {
        clientId             = var.clientId
        clientSecret         = var.clientSecret
      }
      masterProfile = {
        vmSize               = var.master_node_vm_size
        subnetId             = data.azurerm_subnet.master_subnet.id
        encryptionAtHost     = var.master_encryption_at_host
      }
      workerProfiles = [
        {
          name               = var.worker_profile_name
          vmSize             = var.worker_node_vm_size
          diskSizeGB         = var.worker_node_vm_disk_size
          subnetId           = data.azurerm_subnet.master_subnet.id
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

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}