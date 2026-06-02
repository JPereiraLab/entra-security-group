output "group_id" {
  description = "Object ID of the created group"
  value       = azuread_group.security_group.id
}

output "group_display_name" {
  description = "Display name of the created group"
  value       = azuread_group.security_group.display_name
}
