# dbr ID 0520f425-ad8f-40b7-b0a9-26a7772b656c

data azurerm_resource_group deployment_rg {
  name = var.resource_group_name
}
resource "azurerm_resource_group" "vnet_group_name" {
  name = "dbr-${var.environment}-mrg"
  location = var.location
}
resource "azurerm_virtual_network" "dbr_vnet" {
  name                = "${var.vnet_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.vnet_group_name.name
  location            = var.location
  address_space       = ["10.0.0.0/23"]
  tags = {
    environment = var.environment
  }
}
resource "azurerm_network_security_group" "private_dbr_nsg" {
  name                = "dbr-private-${var.environment}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-Databricks-To-Storage"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "Storage"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Allow-Databricks-To-SQL"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "Sql"
    destination_port_range     = "3306"
  }

  security_rule {
    name                       = "Allow-Databricks-To-EventHub"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "EventHub"
    destination_port_range     = "9093"
  }

  security_rule {
    name                       = "AllowAzureDatabricks"
    priority                   = 190
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "AllowAzureOutbound"
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "AzureCloud"
    destination_port_range     = "*"
    priority                   = 200
  }
}
resource "azurerm_network_security_group" "public_dbr_nsg" {
  name                = "dbr-public-${var.environment}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-Databricks-To-Storage"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "Storage"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Allow-Databricks-To-SQL"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "Sql"
    destination_port_range     = "3306"
  }

  security_rule {
    name                       = "Allow-Databricks-To-EventHub"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "EventHub"
    destination_port_range     = "9093"
  }

  security_rule {
    name                       = "AllowAzureDatabricks"
    priority                   = 190
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  virtual_network_name = azurerm_virtual_network.dbr_vnet.name
  resource_group_name  = azurerm_resource_group.vnet_group_name.name
  address_prefixes     = ["10.0.0.0/24"]
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet_name
  virtual_network_name = azurerm_virtual_network.dbr_vnet.name
  resource_group_name  = azurerm_resource_group.vnet_group_name.name
  address_prefixes     = ["10.0.1.0/24"]
    delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_dbr_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_dbr_nsg.id
}
resource "azurerm_user_assigned_identity" "databricks_identity" {
  name                = "databricks-mi"
  resource_group_name = var.resource_group_name
  location            = var.location
}


resource "azurerm_databricks_access_connector" "dbr_access_connector" {
  name                 = "dbr-${var.environment}-access-connector"
  resource_group_name  = var.resource_group_name
  location             = var.location
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.databricks_identity.id
    ]
  }
}


resource "azurerm_databricks_workspace" "dbr_workspace" {
  name                        = "dbr-${var.environment}-workspace"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku                         = "premium"
  managed_resource_group_name = null
  access_connector_id         = azurerm_databricks_access_connector.dbr_access_connector.id
  default_storage_firewall_enabled = true
  network_security_group_rules_required = "NoAzureDatabricksRules"
  
  custom_parameters {
    no_public_ip = true
    virtual_network_id = azurerm_virtual_network.dbr_vnet.id
    public_subnet_name  = azurerm_subnet.public_subnet.name
    private_subnet_name = azurerm_subnet.private_subnet.name
    public_subnet_network_security_group_association_id = azurerm_subnet.public_subnet.id
    private_subnet_network_security_group_association_id = azurerm_subnet.private_subnet.id
  }
  depends_on = [ azurerm_subnet_network_security_group_association.private, azurerm_subnet_network_security_group_association.public ]
}
resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "admin_access" {
  depends_on = [azurerm_key_vault_access_policy.databricks, azurerm_key_vault_key.admin_access]

  workspace_id     = azurerm_databricks_workspace.dbr_workspace.id
  key_vault_key_id = azurerm_key_vault_key.admin_access.id
}

resource "azurerm_key_vault" "admin_access" {
  name                = "admin-access-keyvault"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "premium"

  purge_protection_enabled   = true
  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_key" "admin_access" {
  depends_on = [azurerm_key_vault_access_policy.terraform]

  name         = "admin-access-certificate"
  key_vault_id = azurerm_key_vault.admin_access.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.admin_access.id
  tenant_id    = azurerm_key_vault.admin_access.tenant_id
  object_id    = azurerm_user_assigned_identity.databricks_identity.principal_id
  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
  ]
}

resource "azuread_application" "databricks_app" {
  display_name = "dbr-deployment-${var.environment}"
}

data "azuread_service_principal" "databricks" {
  display_name = "AzureDatabricks"
}

resource "azurerm_key_vault_access_policy" "databricks" {
  depends_on = [azurerm_databricks_workspace.dbr_workspace]

  key_vault_id = azurerm_key_vault.admin_access.id
  tenant_id    = var.tenant_id
  object_id    = data.azuread_service_principal.databricks.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign"
  ]
}
resource "azurerm_role_assignment" "databricks_identity_role_assignment" {
  scope                = azurerm_databricks_workspace.dbr_workspace.id
  role_definition_name = "Contributor"
  principal_id         = azuread_application.databricks_app.object_id
}
resource "azurerm_role_assignment" "databricks_rg_contributor" {
  scope                = data.azurerm_resource_group.deployment_rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.databricks.object_id
}

output "databricks_deployment_spn" {
  value = azuread_application.databricks_app
}