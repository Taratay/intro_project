terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "mystatetask3acct"
    container_name       = "tfstate"
    key                  = "task3.tfstate"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.65.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}
