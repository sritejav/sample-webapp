# Code taken from Terraform documentation for aws_instance

resource "aws_instance" "MyInstance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name        = "Web_server"
    Environment = var.environment
  }
}