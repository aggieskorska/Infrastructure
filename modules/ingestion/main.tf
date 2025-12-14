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
  name                     = "safuncsmarthome${var.environment}"
  resource_group_name      = azurerm_resource_group.ingestion.name
  location                 = azurerm_resource_group.ingestion.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "func_plan" {
  name                = "func-app-plan-smarthome-${var.environment}"
  location            = azurerm_resource_group.ingestion.location
  resource_group_name = azurerm_resource_group.ingestion.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func_app" {
  name                       = "func-app-smarthome-${var.environment}"
  location                   = azurerm_resource_group.ingestion.location
  resource_group_name        = azurerm_resource_group.ingestion.name
  service_plan_id            = azurerm_service_plan.func_plan.id
  storage_account_name       = azurerm_storage_account.functionsa.name
  storage_account_access_key = azurerm_storage_account.functionsa.primary_access_key
  site_config {
    application_stack {
      python_version = "3.10"
    }
    cors {
      allowed_origins = [
        "https://portal.azure.com"
      ]
    }
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "ADLS_ACCOUNT_URL"         = "https://${azurerm_storage_account.functionsa.name}.dfs.core.windows.net"
    "ADLS_FILESYSTEM"          = "raw"
    "ADLS_DIRECTORY"           = ""
    "SUNSYNK_USER"             = var.sunsynk_user
    "SUNSYNK_PASSWORD"         = var.sunsynk_password
    "MEL_USER"                 = var.mel_user
    "MEL_PASSWORD"             = var.mel_password
    "WEATHER_API_URL"          = var.weather_api_url
    "AZURE_STORAGE_KEY"        = azurerm_storage_account.functionsa.primary_access_key

  }

}
