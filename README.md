# entra-security-group

GitHub Actions workflows that create and manage Microsoft Entra ID security 
groups using **OIDC Workload Identity Federation** — no client secrets stored anywhere.

Built as a learning project to demonstrate three approaches to the same task, 
from low-level mechanics to production-grade GitOps.

---

## What's in Here

Three implementations of the same goal — create an Entra security group from CI/CD:

| Workflow | File | Approach |
|----------|------|----------|
| Manual OIDC | `group-manual-oidc.yml` | Raw REST calls, manual token exchange. Educational — shows the underlying OAuth2/OIDC mechanics |
| Azure Login Action | `group-azure-login.yml` | Uses `azure/login@v2` and `az ad group create`. Concise, maintained by Microsoft |
| Terraform (GitOps) | `terraform-apply.yml` + `terraform-plan.yml` | Full IaC with remote state, PR-gated plan/apply pipeline |

All three authenticate using OIDC federation — no client secrets, no certificate rotation.

---

## Authentication Architecture

GitHub Actions Runner
│
│  1. Request OIDC token (proves workflow identity)
▼
GitHub Token Service ──► Short-lived JWT
│
│  2. Exchange JWT for Azure access token
▼
Microsoft Entra ID
│  Checks federated credential:
│  ├─ Issuer   = https://token.actions.githubusercontent.com ✓
│  ├─ Subject  = repo:JPereiraLab/entra-security-group:ref:refs/heads/main ✓
│  └─ Audience = api://AzureADTokenExchange ✓
│
▼
Access Token (Microsoft Graph)
│
│  3. Create/manage security group
▼
Microsoft Graph API ──► Group Created ✅

### Cross-Tenant Setup

Two separate app registrations handle two separate concerns:

| App | Tenant | Purpose |
|-----|--------|---------|
| `GitHub-Entra-Deploy` | `joaolab.com` | Manages Entra resources via Graph API |
| Storage app | Tenant 2 | Reads/writes Terraform state to Azure Storage |

Each app has two federated credentials:
- `github-workflow` → trusts the `main` branch (for apply)
- `github-pull-request` → trusts PR events (for plan)

---

## Prerequisites

### Entra Setup
- App registration in your Entra tenant with `Directory.ReadWrite.All`
- Federated identity credentials configured for GitHub Actions
- App registration in a second tenant with `Storage Blob Data Contributor` on the state storage account

### Azure Setup
- Storage account with a `tfstate` blob container for Terraform remote state

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AZURE_CLIENT_ID` | App ID of the Entra app in `joaolab` tenant |
| `AZURE_TENANT_ID` | Tenant ID of `joaolab` |
| `AZURE_STATE_CLIENT_ID` | App ID of the storage app in tenant 2 |
| `AZURE_STATE_TENANT_ID` | Tenant ID of tenant 2 |
| `AZURE_STATE_SUBSCRIPTION_ID` | Subscription ID in tenant 2 |
| `AZURE_STATE_RG` | Resource group containing the storage account |
| `AZURE_STATE_STORAGE_ACCOUNT` | Storage account name |

---

## File Structure

entra-security-group/
├── .github/
│   └── workflows/
│       ├── group-manual-oidc.yml    # Approach 1: Raw REST + manual OIDC token exchange
│       ├── group-azure-login.yml    # Approach 2: azure/login@v2 + Azure CLI
│       ├── terraform-plan.yml       # Approach 3: Terraform plan (pull requests)
│       └── terraform-apply.yml      # Approach 3: Terraform apply (merge to main)
├── terraform/
│   ├── providers.tf                 # AzureAD provider + remote backend
│   ├── main.tf                      # Security group resources
│   ├── variables.tf                 # Input variables
│   └── outputs.tf                   # Group IDs and names
└── README.md

---

## Running the Workflows

### Approach 1 & 2 (Manual OIDC / Azure Login)
1. Go to **Actions** tab
2. Select the workflow
3. Click **Run workflow**
4. Enter a group name
5. Click **Run workflow**

### Approach 3 (Terraform / GitOps)
Resources are managed through code — not runtime inputs.

**To add or change a group:**
1. Create a new branch
2. Edit `terraform/main.tf` or `terraform/variables.tf`
3. Open a pull request to `main`
4. The plan workflow runs automatically — review the plan comment on the PR
5. Merge the PR
6. The apply workflow runs automatically on `main`
7. Changes are live in Entra

---

## GitOps Flow

Create branch
│
▼
Edit terraform/
│
▼
Open PR ──► terraform fmt      (is code tidy?)
──► terraform validate  (is code correct?)
──► terraform plan      (what will change?)
──► Post plan as PR comment
│
│  Plan shows: 1 to add, 0 to change, 0 to destroy
▼
Review and merge PR
│
▼
Push to main ──► terraform apply ──► Entra updated ✅

**Branch protection on `main` enforces:**
- No direct commits — all changes via PR
- Plan check must pass before merge is allowed
- No force pushes

---

## Key Concepts

**OIDC Workload Identity Federation**
Trust relationship between GitHub and Entra. GitHub proves workflow identity
via a short-lived signed JWT. No secrets stored anywhere.

**Idempotency**
Running the same workflow multiple times produces the same result.
Terraform tracks state — if a group already exists and matches config,
nothing changes.

**Remote State**
Terraform's record of what it has created, stored in Azure Blob Storage.
Enables idempotency across workflow runs and state locking to prevent
concurrent modifications.

**Path Filters**
Workflows only trigger when relevant files change. Editing a README
does not trigger a Terraform plan.

**Declarative vs Imperative**
- Terraform (declarative): describe what should exist, let Terraform figure out how
- REST/CLI (imperative): specify every step explicitly

---

## Approaches Compared

| Aspect | Manual OIDC | Azure Login | Terraform |
|--------|-------------|-------------|-----------|
| Lines of code | ~55 | ~25 | ~30 + workflow |
| Auth handling | Manual REST | `azure/login@v2` | ARM env vars |
| State tracking | None | None | Remote state |
| Idempotent | ❌ | ❌ | ✅ |
| GitOps capable | ❌ | ❌ | ✅ |
| Educational value | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| Production ready | ❌ | ✅ | ✅ |
