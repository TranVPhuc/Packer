packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "jenkins_url" {}
variable "jenkins_secret" {}
variable "agent_name" {}

source "amazon-ebs" "jenkins_agent" {
  profile          = "packer"
  region           = "ap-southeast-1"
  source_ami       = "ami-069cb3204f7a90763" 
  instance_type    = "t2.micro"
  ssh_username     = "ubuntu"
  ami_name         = "jenkins-agent-{{timestamp}}"
  subnet_id        = "subnet-05cb038996001881b"
  associate_public_ip_address = true

}

build {
  name    = "jenkins-agent-ami"
  sources = ["source.amazon-ebs.jenkins_agent"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y unzip openjdk-17-jre-headless curl python3 python3-pip",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "aws --version",
      "sudo mkdir -p /home/ubuntu/agent",
      "sudo chown ubuntu:ubuntu /home/ubuntu/agent",
      "cd /home/ubuntu/agent && sudo -u ubuntu curl -sO ${var.jenkins_url}jnlpJars/agent.jar"
    ]
  }


  provisioner "shell" {
    inline = [<<EOF
cat <<EOT | sudo tee /etc/systemd/system/jenkins-agent.service
[Unit]
Description=Jenkins Agent
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/agent
ExecStart=/usr/bin/java -jar /home/ubuntu/agent/agent.jar -url ${var.jenkins_url} -secret ${var.jenkins_secret} -name ${var.agent_name} -webSocket -workDir /home/ubuntu/agent
Restart=always

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable jenkins-agent
sudo systemctl start jenkins-agent
EOF
    ]
  }
}