resource "azuread_group" "security_group" {
  display_name     = var.group_name
  description      = var.group_description
  security_enabled = true
  mail_enabled     = false
}

resource "azuread_group" "second_group" {
  display_name     = "Second-Test-Group"
  description      = "Added via the GitOps PR flow"
  security_enabled = true
  mail_enabled     = false
}

