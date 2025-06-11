packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "nginx" {
  profile        = "packer"
  region         = "ap-southeast-1"
  source_ami     = "ami-069cb3204f7a90763"
  instance_type  = "t2.micro"
  ssh_username   = "ubuntu"
  ami_name       = "nginx-cloudinit-ami-{{timestamp}}"
  subnet_id      = "subnet-05cb038996001881b"
  user_data_file = "cloud-init.yaml"
}

build {
  name   = "nginx-ami"
  sources = ["source.amazon-ebs.nginx"]

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "echo 'cloud-init done ✅'",
      "systemctl status nginx || journalctl -u nginx"
    ]
  }

}
