resource "random_id" "storage_name" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "storage" {
  name                     = "sta${lower(random_id.storage_name.hex)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "scripts" {
  name                  = local.storage_container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "InstallAgent" {
  name                   = "InstallAgent.ps1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/InstallAgent.ps1"
}

resource "azurerm_storage_blob" "ChocoHelpers" {
  name                   = "ChocoHelpers.ps1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/ChocoHelpers.ps1"
}

resource "azurerm_storage_blob" "ImageHelpersPsd" {
  name                   = "ImageHelpers.psd1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/ImageHelpers.psd1"
}

resource "azurerm_storage_blob" "ImageHelpersPsm" {
  name                   = "ImageHelpers.psm1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/ImageHelpers.psm1"
}

resource "azurerm_storage_blob" "InstallHelpers" {
  name                   = "InstallHelpers.ps1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/InstallHelpers.ps1"
}

resource "azurerm_storage_blob" "PathHelpers" {
  name                   = "PathHelpers.ps1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/PathHelpers.ps1"
}

resource "azurerm_storage_blob" "InitializeVM" {
  name                   = "Initialize-VM.ps1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/Initialize-VM.ps1"
}


resource "azurerm_storage_blob" "InstallVS2019" {
  name                   = "Install-VS2019.ps1"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "${path.module}/scripts/Install-VS2019.ps1"
}

