# How It Works

A plain-English explanation of the Terraform VM alert flow.

## Step 1: The action_group module creates a notification target

The `modules/action_group` module creates an **Azure Monitor Action Group**. This is the object that Azure fires when an alert triggers — it knows who to notify (email addresses, webhooks, etc.).

When deployed, it outputs an `action_group_id` — a long Azure resource ID string. This ID is what the VM alerts module needs to know where to send notifications.

## Step 2: The vm_alerts module creates the alert rules

The `modules/vm_alerts` module creates one **Azure Monitor Metric Alert** per VM in the `vms` list. Each alert watches the VM's CPU Percentage metric and fires when it exceeds the configured threshold.

The key input it needs is `action_group_id` — telling it "when this alert fires, notify this Action Group."

## Step 3: The dev deployment wires the two modules together

Under `terraform-scripts/dev/`, the two modules are deployed as separate Terraform root modules. The `action_group` deployment runs first and produces the `action_group_id`. This ID is then passed as a variable input to the `vm-alerts` deployment.

In a pipeline, Stage 1 deploys the Action Group and captures its output. Stage 2 receives that output as a pipeline variable and passes it into the vm-alerts plan.

## Step 4: tfvars files inject the VM inventory

The `vms` variable in the vm-alerts deployment is a list of VM objects. In `terraform.tfvars`, you add one entry per VM you want to monitor:

    vms = [
      {
        name        = "vm-app-dev-01"
        resource_id = "/subscriptions/.../virtualMachines/vm-app-dev-01"
      }
    ]

To add a new VM to monitoring, you add an entry here. Terraform creates a new alert for it on the next apply. No module changes needed.

## Step 5: The pipeline automates plan and apply

The Azure DevOps pipeline (`pipelines/vm-alerts-dev.yml`) automates the entire sequence. It:
- Authenticates using a service principal (via Service Connection)
- Runs `terraform init` with the remote backend config
- Runs `terraform validate` to catch errors
- Runs `terraform plan` to preview changes
- Runs `terraform apply` to deploy
- Captures the `action_group_id` output from Stage 1 and passes it to Stage 2

## Why the backend may be restricted in enterprise

In enterprise environments, the Azure Storage backend that holds Terraform state is protected by RBAC. Only the pipeline service principal (and designated admins) have access. This prevents state corruption from local runs and ensures all changes go through the pipeline.

If you try to run `terraform init` locally and see an authentication error for the backend, that is expected behavior — not a bug. You can still validate code locally by removing or commenting out the backend block.

## Summary Flow

    Developer writes/updates tfvars (VM inventory)
    --> Pipeline triggers (manual or scheduled)
    --> Stage 1: action_group deploys, outputs action_group_id
    --> Stage 2: vm-alerts deploys, consumes action_group_id
    --> Azure creates/updates metric alerts for each VM
    --> Alerts fire to Action Group when CPU exceeds threshold
    --> Team receives email notifications
