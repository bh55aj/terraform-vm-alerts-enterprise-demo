# ---------------------------------------------------------------------------
# terraform-scripts/dev/vm-alerts/main.tf
#
# DEV environment deployment of the vm_alerts module.
#
# KEY DESIGN: action_group_id is wired in via variable — in pipeline runs
# this is injected from the action_group deployment output. In local runs,
# populate it in terraform.tfvars.
# ---------------------------------------------------------------------------

terraform {
  required_version = ">= 1.3"

    required_providers {
        azurerm = {
              source  = "hashicorp/azurerm"
                    version = ">= 3.0"
                        }
                          }

                            # ---------------------------------------------------------------------------
                              # BACKEND CONFIGURATION (commented out for demo/local use)
                                # Uncomment and configure for enterprise pipeline deployment.
                                  #
                                    # backend "azurerm" {
                                      #   resource_group_name  = "rg-terraform-state"
                                        #   storage_account_name = "<your-storage-account>"
                                          #   container_name       = "tfstate"
                                            #   key                  = "dev/vm-alerts/terraform.tfstate"
                                              # }
                                                # ---------------------------------------------------------------------------
                                                }

                                                provider "azurerm" {
                                                  features {}
                                                  }

                                                  module "vm_alerts" {
                                                    source = "../../../modules/vm_alerts"

                                                      resource_group_name = var.resource_group_name
                                                        action_group_id     = var.action_group_id

                                                          vms           = var.vms
                                                            cpu_threshold = var.cpu_threshold
                                                              severity      = var.severity
                                                                frequency     = var.frequency
                                                                  window_size   = var.window_size
                                                                    tags          = var.tags
                                                                    }

                                                                    # ---------------------------------------------------------------------------
                                                                    # Outputs
                                                                    # ---------------------------------------------------------------------------
                                                                    output "cpu_alert_ids" {
                                                                      description = "Map of VM name to CPU alert resource ID."
                                                                        value       = module.vm_alerts.cpu_alert_ids
                                                                        }

                                                                        output "cpu_alert_names" {
                                                                          description = "Map of VM name to CPU alert name."
                                                                            value       = module.vm_alerts.cpu_alert_names
                                                                            }
