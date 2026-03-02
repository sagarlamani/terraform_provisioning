# Terraform Provisioning (Staging + Production)

This repository provisions AWS infrastructure using Terraform with reusable modules and GitHub Actions GitOps workflow.

## Project Structure

```text
.
├── .github/workflows/terraform-gitops.yml
├── backend.tf
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── environments/
│   ├── staging.tfvars
│   └── production.tfvars
├── modules/
│   ├── networking/
│   ├── security/
│   ├── bastion/
│   └── rds/
└── scripts/
    └── bastion_bootstrap.sh
```

## Provisions (Per Environment)

- 1 VPC
- 2 subnets: public + private
- 1 Internet Gateway + public route table association
- 1 Bastion EC2 instance in public subnet
- 1 RDS instance in private subnet (`publicly_accessible = false`)
- Security groups:
  - SSH to bastion only from `my_ip_cidr`
  - DB access only from bastion security group

## Design Decisions

- **Module design**
  - Infrastructure is split into focused reusable modules: `networking`, `security`, `bastion`, `rds`.
  - Root `main.tf` composes modules once; envs differ only via variable files.

- **Environment handling**
  - Environment identity comes from `var.environment` in each tfvars file.
  - No Terraform workspaces are used now.
  - State separation is by backend key prefix in the same S3 bucket:
    - `staging/terraform.tfstate`
    - `production/terraform.tfstate`

- **State + locking**
  - Backend: S3 for state storage.
  - DynamoDB table for state lock to prevent concurrent writers.

- **Secret handling**
  - `db_password` is not committed in tfvars.
  - It is injected via env var `TF_VAR_db_password` locally and in CI.
  - GitHub secrets used:
    - `STAGING_DB_PASSWORD`
    - `PRODUCTION_DB_PASSWORD`
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `AWS_SESSION_TOKEN` (only for temporary creds)

- **CI/CD behavior**
  - PR to `main`: `fmt`, `validate`, and `plan` (staging).
  - Push to `main`: apply staging.
  - Tag `v*.*.*`: apply production.
  - Manual trigger supported with `target_env` input.
  - Concurrency groups prevent overlapping applies per environment.

## Prerequisites

- Terraform installed (`terraform version`)
- AWS CLI installed (`aws --version`)
- Valid AWS credentials with permissions for VPC/EC2/RDS/SG/S3/DynamoDB
- Existing backend resources:
  - S3 bucket for state
  - DynamoDB table for lock

## Manual Testing Instructions

### 1) Validate formatting and configuration

```bash
terraform fmt -check -recursive
terraform validate
```

### 2) Test staging

```bash
terraform init -reconfigure -backend-config="key=staging/terraform.tfstate"
# PowerShell: $env:TF_VAR_db_password="<staging-password>"
export TF_VAR_db_password="<staging-password>"
terraform plan -var-file="environments/staging.tfvars"
terraform apply -var-file="environments/staging.tfvars"
```

### 3) Test production

```bash
terraform init -reconfigure -backend-config="key=production/terraform.tfstate"
# PowerShell: $env:TF_VAR_db_password="<production-password>"
export TF_VAR_db_password="<production-password>"
terraform plan -var-file="environments/production.tfvars"
terraform apply -var-file="environments/production.tfvars"
```


## Environment Switching Explanation

Switching environment is done by changing **both**:

1) backend state key (at `terraform init` time), and  
2) variable file (at `plan/apply` time).

Example:

- Staging:
  - `terraform init -reconfigure -backend-config="key=staging/terraform.tfstate"`
  - `terraform plan/apply -var-file="environments/staging.tfvars"`

- Production:
  - `terraform init -reconfigure -backend-config="key=production/terraform.tfstate"`
  - `terraform plan/apply -var-file="environments/production.tfvars"`

