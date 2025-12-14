resource "azurerm_resource_group" "environment_rg" {
  name     = "rg-${var.environment}-smarthome"
  location = "West Europe"
}

resource "azurerm_key_vault" "github_kv" {
  name                        = "kv-gh-${var.environment}-smarthome"
  location                    = azurerm_resource_group.environment_rg.location
  resource_group_name         = azurerm_resource_group.environment_rg.name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "st${var.environment}smarthometfstate"
  resource_group_name      = azurerm_resource_group.environment_rg.name
  location                 = azurerm_resource_group.environment_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "infrastructure"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

# resource "azurerm_storage_account_network_rules" "example" {
#   storage_account_id = azurerm_storage_account.datalake_storage.id

#   default_action             = "Deny"
#   bypass                     = ["AzureServices"]
#   virtual_network_subnet_ids = []
#   ip_rules                   = []
# }

output "resource_group" {
  value = azurerm_resource_group.environment_rg
}


output "ado_key_vault" {
  value = azurerm_key_vault.github_kv
}
