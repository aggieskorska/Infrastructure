terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.99.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    tenant_id = "25d63387-d8f7-44d2-94ee-f84273e298e2"
    resource_group_name = "rg-dev-smarthome"
    storage_account_name = "stdevsmarthometfstate"
    container_name       = "infrastructure"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b67854e8-32ff-4ecc-80d2-2ab89b8eeb93"
}

provider "azuread" {
  tenant_id = var.tenant_id
}

# provider "databricks" {
#   azure_workspace_resource_id = var.databricks_workspace_resource_id
# #   azure_client_id             = var.azure_client_id
# #   azure_client_secret         = var.azure_client_secret
# #   azure_tenant_id             = var.tenant_id
# }

provider "databricks" {
  azure_workspace_resource_id = "1365204546860500"
}