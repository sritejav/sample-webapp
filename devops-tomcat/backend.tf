terraform {
  backend "s3" {
    bucket = "samplewebapp-dev"
    key    = "tomcat-terraform.tfstate"
    region = "ap-south-2"
  }
}
