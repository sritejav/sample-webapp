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
variable "name"{
  description = "Name of the Server"
  type = string
  default = "Jenkins-Server"
}