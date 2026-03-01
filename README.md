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

Because `workspace_key_prefix` is set, workspace state is separated automatically:

- `env/staging/terraform.tfstate`
- `env/production/terraform.tfstate`

## Environment selection options

### Option A: tfvars files

Use one root codebase and pass env-specific variables:

```bash
terraform init
terraform plan -var-file="environments/staging.tfvars"
terraform apply -var-file="environments/staging.tfvars"
```

```bash
terraform plan -var-file="environments/production.tfvars"
terraform apply -var-file="environments/production.tfvars"
```

### Option B: Terraform workspaces

The stack resolves environment with:

- `var.environment` when set
- otherwise `terraform.workspace`
- workspace `default` maps to `staging`

Example:

```bash
terraform init
terraform workspace new staging
terraform workspace select staging
terraform plan -var-file="environments/staging.tfvars"
terraform apply -var-file="environments/staging.tfvars"
```

```bash
terraform workspace new production
terraform workspace select production
terraform plan -var-file="environments/production.tfvars"
terraform apply -var-file="environments/production.tfvars"
```

## Notes

- Replace placeholder values in `environments/*.tfvars`:
  - `my_ip_cidr`
  - `bastion_ami_id`
  - `bastion_key_name`
  - `db_password`
- RDS subnet groups require at least two subnets; this setup includes both existing subnets in the subnet group and pins RDS AZ to the private subnet AZ.
