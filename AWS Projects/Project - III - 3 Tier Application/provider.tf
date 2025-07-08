terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  shared_credentials_files = ["C:/Users/PBKW/.aws/credentials"]
  profile = "terraformuser"
}