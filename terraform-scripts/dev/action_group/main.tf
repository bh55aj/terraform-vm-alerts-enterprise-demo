# ---------------------------------------------------------------------------
# terraform-scripts/dev/action_group/main.tf
#
# DEV environment deployment of the action_group module.
# This is run independently from vm-alerts so the Action Group
# can be managed as a standalone resource and its output referenced.
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
                              # BACKEND CONFIGURATION
                                # In enterprise environments, remote state is stored in Azure Storage.
                                  # Uncomment and populate the backend block below when deploying to Azure.
                                    # In local/demo mode, Terraform will use local state by default.
                                      #
                                        # backend "azurerm" {
                                          #   resource_group_name  = "rg-terraform-state"
                                            #   storage_account_name = "<your-storage-account>"
                                              #   container_name       = "tfstate"
                                                #   key                  = "dev/action_group/terraform.tfstate"
                                                  #   # Auth is handled by the pipeline service principal (RBAC).
                                                    #   # Local users may not have access to this backend — use local state for validation.
                                                      # }
                                                        # ---------------------------------------------------------------------------
                                                        }

                                                        provider "azurerm" {
                                                          features {}
                                                            # In pipeline runs, authentication is handled via environment variables:
                                                              # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
                                                                # (set via Azure DevOps Variable Group or Service Connection)
                                                                }

                                                                module "action_group" {
                                                                  source = "../../../modules/action_group"

                                                                    name                = var.action_group_name
                                                                      short_name          = var.action_group_short_name
                                                                        resource_group_name = var.resource_group_name

                                                                          email_receivers = var.email_receivers
                                                                            tags            = var.tags
                                                                            }

                                                                            # ---------------------------------------------------------------------------
                                                                            # Expose outputs for consumption by vm-alerts deployment
                                                                            # ---------------------------------------------------------------------------
                                                                            output "action_group_id" {
                                                                              description = "Action Group resource ID — used as input to the vm-alerts deployment."
                                                                                value       = module.action_group.action_group_id
                                                                                }

                                                                                output "action_group_name" {
                                                                                  description = "Action Group name."
                                                                                    value       = module.action_group.action_group_name
                                                                                    }
