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

module "asg" {
  source               = "./modules/asg"
  name_prefix          = "test"
  ami                  = "ami-03c6be2508740cda4"
  instance_type        = "t2.micro"
  security_group_ids   = ["sg-0c15105dc8a69c9d9"]
  subnet_ids           = ["subnet-056ea440973ae0871", "subnet-056ea440973ae0871", "subnet-042eb0485d4b1065c"]
  min_size             = 0
  max_size             = 1
  desired_capacity     = 0
}
