

resource azurerm_storage_account datalake_storage {
  name                     = "sasmarthome${var.environment}datalake"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled = true
} 

locals {
  containers = [
    "raw", "bronze", "silver", "gold"
  ]
}

resource "azurerm_storage_container" "containers" {
  for_each = toset(local.containers)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.datalake_storage.name
  # container_access_type = "public" 
}

resource "azurerm_storage_data_lake_gen2_path" "solar_dir" {
  for_each = { for key, value in azurerm_storage_container.containers : key => value }
  path               = "solar"
  filesystem_name    = each.value.name
  storage_account_id = azurerm_storage_account.datalake_storage.id
  resource           = "directory"
}
resource "azurerm_storage_data_lake_gen2_path" "heatpump_dir" {
  for_each = { for key, value in azurerm_storage_container.containers : key => value }
  path               = "heatpump"
  filesystem_name    = each.value.name
  storage_account_id = azurerm_storage_account.datalake_storage.id
  resource           = "directory"
}
resource "azurerm_storage_data_lake_gen2_path" "weather_dir" {
  for_each = { for key, value in azurerm_storage_container.containers : key => value }
  path               = "weather"
  filesystem_name    = each.value.name
  storage_account_id = azurerm_storage_account.datalake_storage.id
  resource           = "directory"
}



output "datalake_storage_account_id" {
  value = azurerm_storage_account.datalake_storage.id
}
