packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.7"
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
  iam_instance_profile        = "ec2tos3"
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

  user_data_file = "cloud-init.yaml"
}

build {
  name    = "jenkins-ami"
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "shell" {
    inline = [
      "echo '⏳ Chờ cloud-init hoàn tất...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "echo '✅ cloud-init hoàn tất.'",
      "echo '🔍 Kiểm tra trạng thái Jenkins bằng systemctl...'",
      "sudo systemctl status jenkins || (echo '❌ Jenkins KHÔNG chạy đúng cách'; exit 1)"
    ]
  }
}
