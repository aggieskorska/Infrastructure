module "landing" {
    source      = "./modules/landing"
    environment = var.environment
    tenant_id   = var.tenant_id
}

module "datalake" {
    source      = "./modules/datalake"
    environment = var.environment
    tenant_id   = var.tenant_id
    location    = module.landing.resource_group.location
    resource_group_name = module.landing.resource_group.name
    containers = var.datalake_containers
}

module "ingestion" {
    source      = "./modules/ingestion"
    environment = var.environment
    datalake_storage_account_id = module.datalake.datalake_storage_account_id
    resource_group_name = module.landing.resource_group.name
    location    = module.landing.resource_group.location
    sunsynk_user = var.SUNSYNK_USER
    sunsynk_password = var.SUNSYNK_PASSWORD
    mel_user = var.MEL_USER
    mel_password = var.MEL_PASSWORD
    weather_api_url = var.WEATHER_API_URL
    azure_storage_key = var.AZURE_STORAGE_KEY
}

# module "databricks" {
#     source      = "./modules/databricks"
#     environment = var.environment
#     tenant_id   = var.tenant_id
#     datalake_storage_account_id = module.datalake.datalake_storage_account_id
#     resource_group_name = module.landing.resource_group.name
#     location    = module.landing.resource_group.location
#     vnet_name = var.vnet_name
#     public_subnet_name = var.public_subnet_name
#     private_subnet_name = var.private_subnet_name
# }