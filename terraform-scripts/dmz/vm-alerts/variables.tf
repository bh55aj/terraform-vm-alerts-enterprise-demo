# ---------------------------------------------------------------------------
# terraform-scripts/dmz/vm-alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
    description = "Resource group where DMZ VM alert resources will be created."
    type        = string
}

variable "action_group_id" {
    description = "Resource ID of the DMZ Azure Monitor Action Group."
    type        = string
}

variable "vms" {
    description = "List of DMZ VMs to monitor."
  type = list(object({
        name        = string
        resource_id = string
  }))
}

variable "cpu_threshold" {
    description = "CPU percentage threshold for DMZ alerts."
    type        = number
    default     = 70
}

variable "severity" {
  description = "Alert severity (0=Critical, 1=Error, 2=Warning)."
    type        = number
    default     = 1
  validation {
    condition     = contains([0, 1, 2, 3, 4], var.severity)
        error_message = "severity must be between 0 and 4."
  }
}

variable "frequency" {
  description = "Alert evaluation frequency (ISO 8601)."
    type        = string
    default     = "PT1M"
}

variable "window_size" {
  description = "Metric aggregation window (ISO 8601)."
    type        = string
    default     = "PT5M"
}

variable "tags" {
    description = "Tags to apply to DMZ alert resources."
  type        = map(string)
  default = {
        environment = "dmz"
        managed_by  = "terraform"
        project     = "vm-alerts"
  }
}
