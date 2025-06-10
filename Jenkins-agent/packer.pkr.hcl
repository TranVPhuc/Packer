packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  profile                    = "packer"
  region                     = "ap-southeast-1"
  source_ami                 = "ami-069cb3204f7a90763" 
  instance_type              = "t2.micro"
  ssh_username               = "ubuntu"
  ami_name                   = "jenkins-agent-ami-{{timestamp}}"
  user_data_file             = "cloudinit.yaml"
  associate_public_ip_address = true
}

build {
  name   = "jenkins-agent-build"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo 'Jenkins agent AMI build completed.'"
    ]
  }
}
