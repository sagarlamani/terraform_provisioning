# Terraform Provisioning Architecture

This project uses a **single root stack** with reusable modules to deploy both `staging` and `production` environments without copy-pasting Terraform code.

## What gets provisioned per environment

- 1 VPC
- 2 subnets: 1 public + 1 private
- 1 bastion EC2 instance in the public subnet
- 1 RDS instance with `publicly_accessible = false`
- Security groups:
  - bastion SG: SSH (`22`) only from your IP (`my_ip_cidr`)
  - RDS SG: DB port (`5432` for Postgres, `3306` for MySQL) only from bastion SG
- Bastion bootstrap via `scripts/bastion_bootstrap.sh`

## Backend (S3 + DynamoDB)

`backend.tf` configures an S3 backend with DynamoDB state locking.

Update these values before first init:

- `bucket`
- `dynamodb_table`
- `region`

State is separated by backend key folders in the same bucket:

- `staging/terraform.tfstate`
- `production/terraform.tfstate`

## Environment selection

Use one root codebase and pass env-specific variables:

```bash
terraform init -reconfigure -backend-config="key=staging/terraform.tfstate"
# PowerShell: $env:TF_VAR_db_password="<staging-db-password>"
export TF_VAR_db_password="<staging-db-password>"
terraform plan -var-file="environments/staging.tfvars"
terraform apply -var-file="environments/staging.tfvars"
```

```bash
terraform init -reconfigure -backend-config="key=production/terraform.tfstate"
# PowerShell: $env:TF_VAR_db_password="<production-db-password>"
export TF_VAR_db_password="<production-db-password>"
terraform plan -var-file="environments/production.tfvars"
terraform apply -var-file="environments/production.tfvars"
```

## Notes

- Replace placeholder values in `environments/*.tfvars`:
  - `my_ip_cidr`
  - `bastion_ami_id`
  - `bastion_key_name`
- Set `TF_VAR_db_password` from your shell/CI secret store before plan/apply.
- RDS subnet groups require at least two subnets; this setup includes both existing subnets in the subnet group and pins RDS AZ to the private subnet AZ.
