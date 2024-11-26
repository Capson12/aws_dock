terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.77.0"
      }
    } 
  
}

provider "aws" {
         region = "eu-west-2"
    }

resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/16"

    tags = {
      name =  "smtx_main_vpc"
    }
  
}

resource "aws_subnet" "smtx_sub1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2c"
  map_public_ip_on_launch = true
  
  tags = {
    name = "smtx_subnet1"
  }
  
}

resource "aws_subnet" "smtx_sub2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  map_public_ip_on_launch = true
  
  tags = {
    name = "smtx_subnet1"
  }
  
}