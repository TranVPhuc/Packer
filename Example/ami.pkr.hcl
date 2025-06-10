packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  profile                    = "packer"
  region                     = "ap-southeast-1"
  source_ami                 = "ami-069cb3204f7a90763" # Ubuntu base AMI
  instance_type              = "t2.micro"
  ssh_username               = "ubuntu"
  ami_name                   = "nginx-ami-{{timestamp}}"
  user_data_file             = "cloud-init.yaml"
  associate_public_ip_address = true
}

build {
  name   = "nginx-ami"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo 'AMI with Nginx is ready.'"
    ]
  }
}
