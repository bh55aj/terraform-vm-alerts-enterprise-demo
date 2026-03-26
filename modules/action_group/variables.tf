# ---------------------------------------------------------------------------
# modules/action_group/variables.tf
# ---------------------------------------------------------------------------

variable "name" {
  description = "Name of the Azure Monitor Action Group."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the Action Group will be created."
  type        = string
}

variable "short_name" {
  description = "Short name for the Action Group (max 12 characters)."
  type        = string
  validation {
    condition     = length(var.short_name) <= 12
    error_message = "short_name must be 12 characters or fewer."
  }
}

variable "email_receivers" {
  description = "List of email receivers for the Action Group."
  type = list(object({
    name          = string
    email_address = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the Action Group resource."
  type        = map(string)
  default     = {}
}
