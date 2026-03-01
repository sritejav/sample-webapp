# This is created to add state management
terraform {
  backend "s3" {
    bucket = "samplewebapp-dev"
    key    = "webapp-terraform.tfstate"
    region = "ap-south-2"
  }
}
