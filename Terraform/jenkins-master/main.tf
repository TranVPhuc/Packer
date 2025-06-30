terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  profile = "packer"
}

module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source               = "./modules/ec2"
  ami                  = "ami-0a5dab39a06d6131b"
  instance_type        = "t2.micro"
  subnet_id            = "subnet-05cb038996001881b"
  security_group_ids   = ["sg-0c15105dc8a69c9d9"]
  iam_instance_profile = module.iam.instance_profile_name
}

