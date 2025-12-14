resource "azurerm_resource_group" "ingestion" {
  name = "rg-${var.environment}-ingestion-smarthome"
  location = var.location
}

resource "azurerm_data_factory" "IngestionADF" {
  name                = "ingestionadf${var.environment}smarthome"
  location            = var.location
  resource_group_name = azurerm_resource_group.ingestion.name
  github_configuration {
    account_name   = "aggieskorska"
    repository_name = "Orchestration"
    branch_name = "main"
    root_folder = "/"
  }
}

resource "azurerm_storage_account" "functionsa" {
  name                     = "smarthome${var.environment}funcsa"
  resource_group_name      = azurerm_resource_group.ingestion.name
  location                 = azurerm_resource_group.ingestion.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "azurerm_service_plan" "func_plan" {
  name                = "func-app-plan-${random_id.rand.hex}"
  location            = azurerm_resource_group.ingestion.location
  resource_group_name = azurerm_resource_group.ingestion.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func_app" {
  name                       = "smart-home-func-${random_id.rand.hex}"
  location                   = azurerm_resource_group.ingestion.location
  resource_group_name        = azurerm_resource_group.ingestion.name
  service_plan_id            = azurerm_service_plan.func_plan.id
  storage_account_name       = azurerm_storage_account.functionsa.name
  storage_account_access_key = azurerm_storage_account.functionsa.primary_access_key
  site_config {
    
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "ADLS_ACCOUNT_URL"         = "https://${azurerm_storage_account.functionsa.name}.dfs.core.windows.net"
    "ADLS_FILESYSTEM"          = "raw"
    "SUNSYNC_USER"             = var.sunsync_user
    "SUNSYNC_PASSWORD"         = var.sunsync_password
    "MEL_USER"                 = var.mel_user
    "MEL_PASSWORD"             = var.mel_password
    "WEATHER_API_URL"          = var.weather_api_url
    "AZURE_STORAGE_KEY"        = azurerm_storage_account.functionsa.primary_access_key
  }

}
