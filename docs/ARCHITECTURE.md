# Architecture Overview

## Purpose

This document describes the architecture of the `terraform-vm-alerts-enterprise-demo` repository and how each component maps to a real enterprise Terraform pattern.

## Component Map

    terraform-vm-alerts-enterprise-demo/
        |
            +-- modules/                          Reusable, environment-agnostic Terraform modules
                |   +-- action_group/                 Creates Azure Monitor Action Group
                    |   +-- vm_alerts/                    Creates Azure Monitor metric alerts per VM
                        |
                            +-- terraform-scripts/                Environment-specific deployments
                                |   +-- dev/
                                    |   |   +-- action_group/            DEV: deploys action_group module
                                        |   |   +-- vm-alerts/               DEV: deploys vm_alerts module
                                            |   +-- dmz/                         DMZ: placeholder (mirror dev structure)
                                                |   +-- prd/                         PRD: placeholder (mirror dev structure)
                                                    |
                                                        +-- pipelines/
                                                            |   +-- vm-alerts-dev.yml            Azure DevOps YAML pipeline for DEV
                                                                |
                                                                    +-- docs/                            Architecture and demo documentation

                                                                    ## Module Architecture

                                                                    ### action_group module

                                                                    Creates an `azurerm_monitor_action_group` resource. It accepts a list of email receivers, exposes `action_group_id` as an output, and is designed to be deployed independently so its ID can be consumed by other deployments.

                                                                    ### vm_alerts module

                                                                    Creates `azurerm_monitor_metric_alert` resources, one per VM in the `vms` list. It uses `for_each` to iterate, accepts `action_group_id` as an input, and exposes created alert IDs as outputs. Additional metric types can be added following the same pattern.

                                                                    ## Output Wiring

                                                                    The critical architectural pattern is how `action_group_id` flows into `vm_alerts`:

                                                                        action_group deployment
                                                                                outputs: action_group_id
                                                                                            --> injected into vm-alerts deployment
                                                                                                                module.vm_alerts.action_group_id
                                                                                                                
                                                                                                                In a pipeline, this is captured using Azure DevOps task output variables:
                                                                                                                
                                                                                                                    Stage 1 (action_group apply) --> captures action_group_id
                                                                                                                        Stage 2 (vm-alerts plan/apply) --> uses $(ACTION_GROUP_ID) variable
                                                                                                                        
                                                                                                                        ## Backend / State Architecture
                                                                                                                        
                                                                                                                        In enterprise environments, state is stored in Azure Storage with RBAC-restricted access. Each deployment has its own state key (e.g., `dev/action_group/terraform.tfstate`). Local developers may run `terraform validate` and `terraform plan` without backend access. The backend block is commented out in this demo for local usability.
                                                                                                                        
                                                                                                                        ## tfvars Architecture
                                                                                                                        
                                                                                                                            terraform.tfvars.example  -->  copy to terraform.tfvars
                                                                                                                                                                   |
                                                                                                                                                                                                    populate with real values
                                                                                                                                                                                                                                           |
                                                                                                                                                                                                                                                                      terraform plan -var-file=terraform.tfvars
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      The `vms` variable is a list of objects allowing dynamic alert creation for any number of VMs without modifying Terraform code.
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      ## Pipeline Architecture
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      The Azure DevOps pipeline:
                                                                                                                                                                                                                                                                      1. Installs Terraform
                                                                                                                                                                                                                                                                      2. Authenticates via service connection (service principal)
                                                                                                                                                                                                                                                                      3. Runs init/validate/plan/apply for action_group
                                                                                                                                                                                                                                                                      4. Captures `action_group_id` from Stage 1 output
                                                                                                                                                                                                                                                                      5. Runs init/validate/plan/apply for vm-alerts using the captured ID
                                                                                                                                                                                                                                                                      6. Runs on a daily schedule and on main branch changes
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      ## Azure Resources Created
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      When fully deployed, this pattern creates one `azurerm_monitor_action_group` per environment and one `azurerm_monitor_metric_alert` per VM in the inventory.
