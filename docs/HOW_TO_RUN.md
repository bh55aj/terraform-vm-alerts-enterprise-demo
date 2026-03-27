# How To Run Locally

This guide explains how to validate and run the demo Terraform code locally.

## Prerequisites

- Terraform >= 1.3 installed (`terraform -version`)
- Git installed
- Optional: Azure CLI installed (for plan/apply against real Azure)

## Clone the Repository

```bash
git clone https://github.com/ausjones84/terraform-vm-alerts-enterprise-demo.git
cd terraform-vm-alerts-enterprise-demo
```

## Validate the action_group module

```bash
cd terraform-scripts/dev/action_group

# Copy example vars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — at minimum set resource_group_name

# Initialize (uses local state since backend is commented out)
terraform init

# Validate syntax and structure
terraform validate
# Expected output: "Success! The configuration is valid."

# Preview (requires Azure login for real plan)
terraform plan -var-file=terraform.tfvars
```

## Validate the vm-alerts module

```bash
cd terraform-scripts/dev/vm-alerts

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars:
#   - Set resource_group_name
#   - Set action_group_id (from Azure portal or action_group output)
#   - Set vms list with real VM names and resource IDs

terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```

## Making Validate Pass Without Azure

`terraform validate` checks syntax and module structure without connecting to Azure. It will pass cleanly on this demo code.

`terraform plan` requires Azure credentials. If you don't have them:
- Set dummy values in terraform.tfvars
- Run `terraform init` and `terraform validate` — those will pass
- The plan will fail at the provider authentication step, which is expected

## Backend Notes

The backend block in each `main.tf` is commented out. This means Terraform uses local state by default. Do NOT run `terraform apply` against real Azure resources unless you have:
1. Uncommented and configured the backend block
2. A real resource group and storage account for state
3. Azure credentials configured (`az login` or service principal env vars)

## Running a Full Local Plan (with Azure credentials)

```bash
# Authenticate with Azure CLI
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# In terraform-scripts/dev/action_group
terraform init
terraform plan -var-file=terraform.tfvars

# In terraform-scripts/dev/vm-alerts
terraform init
terraform plan -var-file=terraform.tfvars
```

## Local State Cleanup

After local testing, remove local state files before committing:

```bash
find . -name "terraform.tfstate*" -not -path "*/.git/*" -delete
find . -name ".terraform" -type d -exec rm -rf {} +
find . -name ".terraform.lock.hcl" -delete
```

These files are already covered by `.gitignore`.
