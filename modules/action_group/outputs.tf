# ---------------------------------------------------------------------------
# modules/action_group/outputs.tf
# ---------------------------------------------------------------------------

output "action_group_id" {
  description = "The resource ID of the Azure Monitor Action Group."
  value       = azurerm_monitor_action_group.this.id
}

output "action_group_name" {
  description = "The name of the Azure Monitor Action Group."
  value       = azurerm_monitor_action_group.this.name
}
