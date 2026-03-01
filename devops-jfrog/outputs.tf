# Outputs for the AWS resources created by this configuration

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "The public IP address assigned to the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.web.public_dns
}

output "instance_ami" {
  description = "The AMI used to launch the instance"
  value       = aws_instance.web.ami
}

output "instance_type" {
  description = "The type of the instance provisioned"
  value       = aws_instance.web.instance_type
}

output "jenkins_url" {
  value = "https://${aws_instance.web.public_ip}:8080"
}