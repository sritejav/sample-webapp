# Variables
variable "ami" {
  default = "ami-02774d409be696d81"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {
  description = "name of the ssh keypair"
  default     = "teja-sshkey"
}
variable "environment" {
  description = "Environment for the resources"
  default     = "dev"
}
variable "project_name" {
  description = "Name of the project"
  default     = "Sample-WebApp"
}
variable "name" {
  description = "Name of the resource"
  type        = string
  default     = "Sonarqube-Server"
}
variable "Created_By" {
  description = "Name of the resource creator"
  type        = string
  default     = "IaC Terraform"
}
variable "owner_email" {
  description = "Email address of the resource owner"
  type        = string
  default     = "teja"
}