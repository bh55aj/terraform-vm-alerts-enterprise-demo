# DMZ Environment

This environment follows the same structure as `dev`.

Subdirectories to create when deploying to DMZ:

```
terraform-scripts/dmz/
  action_group/
      main.tf
          variables.tf
              terraform.tfvars       # (not committed — injected via pipeline)
                vm-alerts/
                    main.tf
                        variables.tf
                            terraform.tfvars       # (not committed — injected via pipeline)
                            ```

                            Copy the `dev` structure and update:
                            - Resource group names (e.g., `rg-monitoring-dmz`)
                            - Action Group name (e.g., `ag-vm-alerts-dmz`)
                            - VM inventory (DMZ VMs in tfvars)
                            - Backend state key (e.g., `dmz/action_group/terraform.tfstate`)

                            See `docs/HOW_TO_DEPLOY_TO_AZURE.md` for deployment guidance.
