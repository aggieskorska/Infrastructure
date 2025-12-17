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
    publishing_enabled = true
    root_folder = "/"
    git_url = "https://github.com"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "adf_adls_role" {
  principal_id   = azurerm_data_factory.IngestionADF.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = var.datalake_storage_account_id
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
  identity {
    type = "SystemAssigned"

  }
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


resource "azurerm_role_assignment" "adf_fun_app_role" {
  principal_id   = azurerm_data_factory.IngestionADF.identity[0].principal_id
  role_definition_name = "Contributor"
  scope          = azurerm_linux_function_app.func_app.id
}

resource "azurerm_role_assignment" "function_adls_role" {
  principal_id   = azurerm_linux_function_app.func_app.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = var.datalake_storage_account_id
}