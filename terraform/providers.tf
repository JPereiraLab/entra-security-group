terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Backend config provided via -backend-config flags in the workflow
    use_oidc = true
  }
}

provider "azuread" {
  use_oidc  = true
  client_id = var.entra_client_id
  tenant_id = var.entra_tenant_id
}
