terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    } 
  
}

provider "aws" {
         region = "eu-west-2"
    }

resource "aws_vpc" "vpc1" {

    arn = "smtx_vpc_main"
    cidr_block = "10.0.0.0/16"
  
}