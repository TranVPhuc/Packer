resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  security_groups        = var.security_group_ids

  tags = {
    Name = "Jenkins-master"
  }
}