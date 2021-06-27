terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }

  required_version = "~> 1.0.0"
}