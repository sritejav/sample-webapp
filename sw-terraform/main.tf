# Code taken from Terraform documentation for aws_instance

resource "aws_instance" "MyInstance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = file("user-date.sh")

  tags = {
    Name = "Web_server"
    Environment  = var.environment
    Project_name = var.project_name
  }
}