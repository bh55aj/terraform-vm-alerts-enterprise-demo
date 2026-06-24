# ---------------------------------------------------------------------------
# terraform-scripts/prd/action_group/main.tf
#
# PRD (Production) environment deployment of the action_group module.
# Production deployments require pipeline-only apply — no manual runs.
# All changes must go through Azure DevOps with approval gates.
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
                              # BACKEND CONFIGURATION — REQUIRED for PRD
                                # Remote state is mandatory in production. Uncomment and populate.
                                  # ---------------------------------------------------------------------------
                                    # backend "azurerm" {
                                      #   resource_group_name  = "rg-terraform-state-prd"
                                        #   storage_account_name = "YOUR_STORAGE_ACCOUNT"
                                          #   container_name       = "tfstate-prd"
                                            #   key                  = "prd/action_group/terraform.tfstate"
                                              # }
                                              }

                                              provider "azurerm" {
                                                features {}
                                                  # Service principal credentials injected via pipeline Variable Group:
                                                    # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
                                                    }

                                                    module "action_group" {
                                                      source = "../../../modules/action_group"

                                                        name                = var.action_group_name
                                                          resource_group_name = var.resource_group_name
                                                            short_name          = var.short_name
                                                              email_receivers     = var.email_receivers
                                                                tags                = var.tags
                                                                }

                                                                output "action_group_id" {
                                                                  description = "Resource ID of the PRD Action Group — inject into prd/vm-alerts as action_group_id."
                                                                    value       = module.action_group.action_group_id
                                                                    }
