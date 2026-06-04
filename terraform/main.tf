resource "azuread_group" "security_group" {
  display_name     = var.group_name-first
  description      = var.group_description-first
  security_enabled = true
  mail_enabled     = false
}

resource "azuread_group" "second_group" {
  display_name     = var.group_name-second
  description      = var.group_description-second
  security_enabled = true
  mail_enabled     = false
}

