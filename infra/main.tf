terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4"
    }
  }
}

provider "aws" {}
