output "instance_id" {
  description = "The ID of the SonarQube EC2 instance"
  value       = aws_instance.sonarqube.id
}

output "instance_public_ip" {
  description = "The public IP address of the SonarQube instance"
  value       = aws_instance.sonarqube.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the SonarQube instance"
  value       = aws_instance.sonarqube.public_dns
}

output "sonarqube_url" {
  description = "URL to access SonarQube"
  value       = "http://${aws_instance.sonarqube.public_ip}:9000"
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sonarqube_sg.id
}

output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.sonarqube_role.arn
}