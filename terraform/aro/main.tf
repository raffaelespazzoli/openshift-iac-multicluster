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
  backend "kubernetes" {
    secret_suffix    = "state"
    in_cluster_config = true
    namespace = crossplane-system
  }  
}


provider "azurerm" {
  features {}
  client_id = var.clientId
  client_secret = var.clientSecret
  subscription_id = var.subscriptionId
  tenant_id = var.tenantId
  use_cli = false
}

provider "azapi" {
  client_id = var.clientId
  client_secret = var.clientSecret
  subscription_id = var.subscriptionId
  tenant_id = var.tenantId
  use_cli = false
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

data "azurerm_resource_group" "resource_group" {
  name                = var.resource_group_name
}

resource "azapi_resource" "aro_cluster" {
  name      = "${var.resource_prefix != "" ? var.resource_prefix : random_string.resource_prefix.result}Aro"
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

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}