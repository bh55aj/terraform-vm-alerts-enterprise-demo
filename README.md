# terraform-vm-alerts-enterprise-demo

> Enterprise-grade Terraform demo for Azure VM alerting — reusable modules, multi-environment deployments (DEV / DMZ / PRD), action group output wiring, tfvars-driven VM inventory, and Azure DevOps YAML pipeline integration.

---

## Overview

This repository demonstrates how a real enterprise team would deploy Azure Monitor VM metric alerts at scale using Terraform. It is purpose-built to show hiring managers and technical interviewers:

- Clean modular Terraform architecture (reusable `modules/` consumed by environment-specific `terraform-scripts/`)
- Multi-environment support: **DEV**, **DMZ**, and **PRD**
- Action Group output wiring pattern (no hardcoded resource IDs)
- Azure DevOps YAML pipelines for automated CI/CD
- tfvars-driven VM inventory for scalable fleet management
- Enterprise-grade alert coverage: CPU, Memory, Disk, and Network

---

## Repository Structure

```
terraform-vm-alerts-enterprise-demo/
├── modules/
│   ├── action_group/          # Reusable Azure Monitor Action Group module
│   └── vm_alerts/             # Reusable VM metric alert module (CPU, Memory, Disk)
├── terraform-scripts/
│   ├── dev/                   # DEV environment deployments
│   │   ├── action_group/
│   │   └── vm-alerts/
│   ├── dmz/                   # DMZ environment deployments
│   │   ├── action_group/
│   │   └── vm-alerts/
│   └── prd/                   # Production environment deployments
│       ├── action_group/
│       └── vm-alerts/
├── pipelines/
│   ├── vm-alerts-dev.yml      # Azure DevOps pipeline — DEV
│   ├── vm-alerts-dmz.yml      # Azure DevOps pipeline — DMZ
│   └── vm-alerts-prd.yml      # Azure DevOps pipeline — PRD
└── docs/
    ├── ARCHITECTURE.md
        ├── DEMO_TALK_TRACK.md
            ├── ENTERPRISE_MAPPING.md
                ├── HOW_IT_WORKS.md
                    ├── HOW_TO_DEPLOY_TO_AZURE.md
                        └── HOW_TO_RUN.md
                        ```

                        ---

                        ## Alert Coverage

                        | Alert Type | Metric | Default Threshold | Severity |
                        |---|---|---|---|
                        | CPU | `Percentage CPU` | > 80% | Warning (2) |
                        | Memory | `Available Memory Bytes` | < 500 MB | Warning (2) |
                        | OS Disk Read | `OS Disk Read Bytes/sec` | > 50 MB/s | Informational (3) |
                        | Network In | `Network In Total` | > 500 MB/5min | Informational (3) |

                        ---

                        ## Environments

                        | Environment | Purpose | State Backend | Apply Method |
                        |---|---|---|---|
                        | DEV | Development and testing | Azure Storage (dev container) | Pipeline or local |
                        | DMZ | Demilitarized zone / perimeter | Azure Storage (dmz container) | Pipeline only |
                        | PRD | Production | Azure Storage (prd container) | Pipeline + approval gate |

                        ---

                        ## Quick Start (Local)

                        ```bash
                        # 1. Clone the repo
                        git clone https://github.com/ausjones84/terraform-vm-alerts-enterprise-demo.git
                        cd terraform-vm-alerts-enterprise-demo

                        # 2. Deploy the Action Group first
                        cd terraform-scripts/dev/action_group
                        cp terraform.tfvars.example terraform.tfvars
                        # Edit terraform.tfvars with your values
                        terraform init
                        terraform validate
                        terraform plan -var-file=terraform.tfvars
                        terraform apply -var-file=terraform.tfvars

                        # 3. Copy the action_group_id output, then deploy VM alerts
                        cd ../vm-alerts
                        cp terraform.tfvars.example terraform.tfvars
                        # Paste action_group_id into terraform.tfvars
                        terraform init
                        terraform validate
                        terraform plan -var-file=terraform.tfvars
                        ```

                        ---

                        ## Key Design Patterns

                        **Action Group Output Wiring** — The `action_group_id` is never hardcoded. In pipelines it flows from the action_group stage output as a pipeline variable. In local runs it is pasted into `terraform.tfvars`. This decouples the Action Group lifecycle from alert rules.

                        **tfvars-Driven VM Inventory** — The list of monitored VMs lives in `terraform.tfvars`, not in code. Adding or removing a VM requires only a tfvars change — no Terraform code modifications needed.

                        **Module Reuse** — The same `modules/vm_alerts` and `modules/action_group` are consumed by all three environments. Environment-specific values are injected via tfvars only.

                        ---

                        ## CDC / Enterprise Use Case

                        This pattern was developed for enterprise environments with strict change control requirements (e.g., CDC, federal agencies, large healthcare organizations) where:

                        - All production changes must go through approved pipelines
                        - Terraform state must be stored in secured Azure Storage with RBAC
                        - VM alert coverage must span multiple network segments (DEV / DMZ / PRD)
                        - Alert notifications must route to environment-specific action groups

                        ---

                        ## Documentation

                        | Doc | Description |
                        |---|---|
                        | [ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture and component diagram |
                        | [HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md) | Deep dive on how the modules work together |
                        | [HOW_TO_RUN.md](docs/HOW_TO_RUN.md) | Local run instructions |
                        | [HOW_TO_DEPLOY_TO_AZURE.md](docs/HOW_TO_DEPLOY_TO_AZURE.md) | Full Azure deployment guide |
                        | [ENTERPRISE_MAPPING.md](docs/ENTERPRISE_MAPPING.md) | Demo-to-enterprise component mapping |
                        | [DEMO_TALK_TRACK.md](docs/DEMO_TALK_TRACK.md) | Interview/demo talk track |

                        ---

                        ## Tech Stack

                        - **Terraform** >= 1.3
                        - **Azure Provider** (hashicorp/azurerm) >= 3.0
                        - **Azure Monitor** — Metric Alerts + Action Groups
                        - **Azure DevOps** — YAML Pipelines
                        - **HCL** — 100% of infrastructure code

                        ---

                        *Built by [@ausjones84](https://github.com/ausjones84) — AI Cloud Engineer / Platform Engineer*
