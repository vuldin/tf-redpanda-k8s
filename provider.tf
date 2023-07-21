terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.73"
    }
    kubernetes = {
      version = "= 2.17.0"
    }
    local = {
      version = "= 2.3.0"
    }
  }
}

provider "local" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.
  default_tags {
    tags = {
      Name = var.cluster_name
    }
  }
  region = var.region
}
