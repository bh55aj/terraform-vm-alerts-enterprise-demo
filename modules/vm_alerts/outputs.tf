# ---------------------------------------------------------------------------
# modules/vm_alerts/outputs.tf
# ---------------------------------------------------------------------------

output "cpu_alert_ids" {
  description = "Map of VM name to CPU alert resource ID."
  value       = { for k, v in azurerm_monitor_metric_alert.cpu : k => v.id }
}

output "cpu_alert_names" {
  description = "Map of VM name to CPU alert resource name."
  value       = { for k, v in azurerm_monitor_metric_alert.cpu : k => v.name }
}
