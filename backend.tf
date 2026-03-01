terraform {
  backend "s3" {
    bucket               = "terraform-state-bucket-sag"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "env"
    region               = "ap-south-1"
    dynamodb_table       = "terraform-locks"
    encrypt              = true
  }
}
