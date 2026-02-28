# Variables

variable "ami" {
  default = "ami-01cfb0266fc955899"
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