# Workflows

This folder contains GitHub Actions workflows for managing 
Entra ID security groups via OIDC Workload Identity Federation.

## Structure

.github/workflows/
├── group-manual-oidc.yml    ← Educational: raw REST/OAuth2 token exchange
├── group-azure-login.yml    ← Production: azure/login@v2 + Azure CLI
├── terraform-plan.yml       ← GitOps: terraform plan on pull requests
└── terraform-apply.yml      ← GitOps: terraform apply on merge to main


## How They Relate

| File | Trigger | What It Does |
|------|---------|--------------|
| `group-manual-oidc.yml` | Manual | Creates a group using raw REST calls |
| `group-azure-login.yml` | Manual | Creates a group using `azure/login@v2` |
| `terraform-plan.yml` | Pull Request | Runs `fmt`, `validate`, `plan` — posts result as PR comment |
| `terraform-apply.yml` | Push to `main` | Runs `plan` then `apply` — deploys to Entra |

## Authentication

All workflows authenticate to Entra ID using **OIDC Workload Identity 
Federation** — no client secrets stored in GitHub.

- `terraform-plan.yml` uses the `pull_request` federated credential
- Everything else uses the `main` branch federated credential
