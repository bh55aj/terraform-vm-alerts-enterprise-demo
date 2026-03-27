# Enterprise Mapping

This document maps each component of the demo repository to its equivalent in a real enterprise Terraform deployment.

## Directory Structure Mapping

| Demo Location | Enterprise Equivalent | Purpose |
|---|---|---|
| `modules/action_group/` | Internal shared module registry | Reusable, versioned module |
| `modules/vm_alerts/` | Internal shared module registry | Reusable, versioned module |
| `terraform-scripts/dev/` | `terraform-scripts/dev/` | DEV environment deployments |
| `terraform-scripts/dmz/` | `terraform-scripts/dmz/` | DMZ environment deployments |
| `terraform-scripts/prd/` | `terraform-scripts/prd/` | Production environment deployments |
| `pipelines/vm-alerts-dev.yml` | Azure DevOps pipeline definition | Automated CI/CD |
| `terraform.tfvars.example` | Secure file / Variable Group | Environment-specific values |

## Component Mapping

### modules/ = Reusable Building Blocks

In enterprise Terraform, modules are authored once and consumed by all environments. They contain no environment-specific values. Any fix or improvement to a module benefits every environment that uses it.

In this demo: `modules/action_group/` and `modules/vm_alerts/` are those building blocks.

### terraform-scripts/{env}/ = Environment Deployments

Each environment folder is a Terraform root module that calls one or more modules with environment-specific values. It contains `main.tf` (module calls), `variables.tf` (variable declarations), and `terraform.tfvars` (values, never committed).

### Remote State = Azure Storage Backend

In enterprise: an Azure Storage Account holds all Terraform state files, with RBAC access restricted to the pipeline service principal. Local developers cannot read or write state — this is a deliberate security boundary.

In this demo: the backend block is commented out so local validation works without credentials.

### Pipelines = Execution Mechanism

In enterprise: Azure DevOps YAML pipelines are the only authorized path to apply Terraform changes to production-class environments. Manual `terraform apply` is blocked in PRD.

In this demo: `pipelines/vm-alerts-dev.yml` shows the complete pipeline pattern.

### Service Principals = Backend Owners

In enterprise: a service principal (app registration) with specific Azure RBAC roles is created for each environment. The pipeline authenticates as this service principal. It has `Contributor` on the monitoring resource group and `Storage Blob Data Contributor` on the state storage account.

### tfvars = VM Inventory and Config Injection

In enterprise: `terraform.tfvars` files contain VM resource IDs and environment-specific settings. These are never committed to source control. In pipelines, values are injected via Variable Groups, pipeline variables, or secure file downloads.

### output wiring = Dependency Chain

In enterprise: Action Groups are pre-provisioned resources. Their resource IDs are injected into alert deployments via pipeline variable passing. This mirrors the pattern in this demo where `action_group_id` flows from Stage 1 to Stage 2.

## What Would Change in a Real Deployment

| Demo Item | Change for Real Enterprise |
|---|---|
| Backend block (commented out) | Uncommented with real storage account |
| Placeholder subscription IDs | Real subscription IDs |
| `terraform.tfvars.example` | `terraform.tfvars` generated in pipeline |
| `YOUR_SERVICE_CONNECTION` | Real Azure DevOps service connection name |
| `YOUR_VARIABLE_GROUP` | Real Variable Group with secure values |
| Example email addresses | Real team email addresses |
| Example VM resource IDs | Real VM resource IDs from Azure |
