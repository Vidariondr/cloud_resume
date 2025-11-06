terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  backend "s3" {
    bucket = "cloudresume-jk729-tfstate"
    key = "env/prod/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    use_lockfile = true
    profile = "tf-state-profile"
  }

  required_version = ">= 1.13"
}