# ---------------------------------------------------------------------------
# terraform-scripts/prd/vm-alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
    description = "Resource group where PRD VM alert resources will be created."
    type        = string
}

variable "action_group_id" {
    description = "Resource ID of the PRD Azure Monitor Action Group. Injected from prd/action_group pipeline output."
    type        = string
}

variable "vms" {
    description = "List of PRD VMs to monitor. Each entry requires name and resource_id."
  type = list(object({
        name        = string
        resource_id = string
  }))
}

variable "cpu_threshold" {
  description = "CPU percentage threshold for PRD alerts (lower = more sensitive)."
    type        = number
    default     = 75
}

variable "severity" {
  description = "Alert severity (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
    type        = number
    default     = 1
  validation {
    condition     = contains([0, 1, 2, 3, 4], var.severity)
        error_message = "severity must be between 0 and 4."
  }
}

variable "frequency" {
  description = "How often the alert is evaluated (ISO 8601)."
    type        = string
    default     = "PT1M"
}

variable "window_size" {
  description = "Period over which the metric is aggregated (ISO 8601)."
    type        = string
    default     = "PT5M"
}

variable "tags" {
    description = "Tags to apply to PRD alert resources."
  type        = map(string)
  default = {
        environment = "prd"
        managed_by  = "terraform"
        project     = "vm-alerts"
  }
}
