

resource azurerm_storage_account datalake_storage {
  name                     = "stlake${var.environment}datalake"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
} 

resource azurerm_storage_data_lake_gen2_filesystem datalake_filesystem {
  name               = "raw"
  storage_account_id = azurerm_storage_account.datalake_storage.id
}

output "datalake_storage_account_id" {
  value = azurerm_storage_account.datalake_storage.id
}
