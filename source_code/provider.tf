terraform {
  # required_version = ">= 1.2.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " >= 3.63"
    }
  }
}

provider "aws" {
  # access_key = "$AWS_ACCESS_KEY_ID"
  # secret_key = "$AWS_SECRET_ACCESS_KEY"
  region = var.region
}