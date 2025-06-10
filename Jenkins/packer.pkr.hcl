packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "instance_type" {
  default = "t2.micro"
}

source "amazon-ebs" "jenkins" {
  profile                     = "packer"
  region                      = var.aws_region
  instance_type               = var.instance_type
  ami_name                    = "jenkins-ami-{{timestamp}}"
  source_ami                  = "ami-069cb3204f7a90763"
  ssh_username                = "ubuntu"
  associate_public_ip_address = true
  subnet_id                   = "subnet-05cb038996001881b"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 12
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "packer-jenkins"
  }
}

build {
  name    = "jenkins-ami"
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-17-jdk wget gnupg curl gpg",
      "sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java",
      "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor | sudo tee /usr/share/keyrings/jenkins-keyring.gpg > /dev/null",
      "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins",
      "sudo systemctl enable jenkins"
    ]
  }

}
