# Security Group for SonarQube
resource "aws_security_group" "sonarqube_sg" {
  name        = "sonarqube-sg"
  description = "Allow SSH, HTTP and SonarQube"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "sonarqube-security-group"
    Environment  = var.environment
    Project_Name = var.project_name
    Created_By   = var.Created_By
  }
}

# IAM Role for EC2 
resource "aws_iam_role" "sonarqube_role" {
  name = "sonarqube-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name         = "sonarqube-iam-role"
    Environment  = var.environment
    Project_Name = var.project_name
    Created_By   = var.Created_By
  }
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "sonarqube_role_attachment" {
  role       = aws_iam_role.sonarqube_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# IAM S3 Access Policy
resource "aws_iam_role_policy_attachment" "sonarqube_s3_access" {
  role       = aws_iam_role.sonarqube_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM SSM Access Policy
resource "aws_iam_role_policy_attachment" "sonarqube_ssm_access" {
  role       = aws_iam_role.sonarqube_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "sonarqube_instance_profile" {
  name = "sonarqube-instance-profile"
  role = aws_iam_role.sonarqube_role.name

  tags = {
    Name         = "sonarqube-instance-profile"
    Environment  = var.environment
    Project_Name = var.project_name
    Created_By   = var.Created_By
  }
}

# EC2 Instance
resource "aws_instance" "sonarqube" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.sonarqube_instance_profile.name
  user_data              = file("${path.module}/user-data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name         = var.name
    Environment  = var.environment
    Project_Name = var.project_name
    Created_By   = var.Created_By
  }
}

# Resources
# Tags 
# Argument Reference  : inside the resources block 
# Attribute Reference : Outputs
# Test Line 
