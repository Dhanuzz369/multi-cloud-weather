terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

# ------------------------------
# MODULE 1: AWS Infrastructure
# ------------------------------
module "aws_infra" {
  source = "./aws"
}

# ------------------------------
# MODULE 2: Azure Failover Infra
# ------------------------------
module "azure_failover" {
  source = "./azure"
}

# ------------------------------
# MODULE 3: Route53 Failover Setup
# ------------------------------
module "route53" {
  source       = "./route53"
  primary_ip   = module.aws_infra.backend_public_ip
  secondary_ip = module.azure_failover.azure_failover_public_ip
}