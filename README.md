# entra-security-group

GitHub Actions workflows that create Microsoft Entra ID security groups using 
**OIDC workload identity federation** — no client secrets required.

## What's in here

Two implementations of the same task, kept side-by-side for comparison:

| Workflow | Approach | When to use |
|----------|----------|-------------|
| [`create-group-manual-oidc.yml`](.github/workflows/create-group-manual-oidc.yml) | Raw REST calls to handle the OIDC token exchange manually | Learning the underlying OAuth2/OIDC mechanics |
| [`create-group-azure-login.yml`](.github/workflows/create-group-azure-login.yml) | Uses the official `azure/login@v2` action and `az ad group create` | Production — concise, maintained by Microsoft |

Both workflows authenticate using the same federated identity credential on the 
same app registration in Entra. The difference is purely in implementation style.

## Authentication Flow

1. GitHub Actions requests an OIDC token from its own token service
2. The token is exchanged at Entra's token endpoint for a Microsoft Graph access token
3. The access token is used to call the Graph API and create the security group

No client secrets are stored anywhere — trust is based on the federated credential 
matching the repository, branch, and audience claims in the GitHub OIDC token.

## Setup Requirements

- An app registration in Entra with `Directory.ReadWrite.All` (or `Group.ReadWrite.All`)
- A federated identity credential trusting `repo:JPereiraLab/entra-security-group:ref:refs/heads/main`
- Two GitHub repository secrets:
  - `AZURE_CLIENT_ID`: the app registration's application (client) ID
  - `AZURE_TENANT_ID`: your Entra tenant ID

## Running

Go to the **Actions** tab, choose either workflow, click **Run workflow**, and 
provide a group name.
