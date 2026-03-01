#!/bin/bash

# Package Management
# Search a Software is installed or not
# Documentation
# Configuration
# Binary Files
# DocumentRoot
# Log Files
# Controlling Services & Daemons

# We get this info from the website of Jenkins to install Jenkins on the Ubuntu Linux EC2 machine 


set -e

# Update packages 
apt update -y # apt or apt-get or dnf 

# Install Java 21
apt install -y openjdk-21-jdk fontconfig openjdk-21-jre

# Verify Java
java -version

# Add Jenkins repository
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y

# Enable & Start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Allow firewall if enabled
ufw allow 8080 || true
