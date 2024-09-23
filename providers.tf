terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_key
    region         = var.backend_region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = var.backend_encrypt                                
  }
}