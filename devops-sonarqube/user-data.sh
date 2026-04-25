# Install Docker on Ubuntu Server

#Setup Hostname
sudo hostnamectl set-hostname "sonarqube.sampleApp.in"

#Update the hostname part of Host File
echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts

#!/bin/bash
set -e

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create directories for SonarQube
sudo mkdir -p /opt/sonarqube
cd /opt/sonarqube

# Create docker-compose.yml
sudo bash -c 'cat > /opt/sonarqube/docker-compose.yml << EOF
version: "3.8"

services:
  postgres:
    image: postgres:15-alpine
    container_name: sonarqube-postgres
    environment:
      POSTGRES_USER: sonarqube
      POSTGRES_PASSWORD: sonarqube123
      POSTGRES_DB: sonarqube
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - sonarqube-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonarqube"]
      interval: 10s
      timeout: 5s
      retries: 5

  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonarqube
      SONAR_JDBC_PASSWORD: sonarqube123
      sonar.es.bootstrap.checks.disable: "true"
    volumes:
      - sonarqube-data:/opt/sonarqube/data
      - sonarqube-logs:/opt/sonarqube/logs
      - sonarqube-extensions:/opt/sonarqube/extensions
    ports:
      - "9000:9000"
    networks:
      - sonarqube-network
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped

networks:
  sonarqube-network:
    driver: bridge

volumes:
  postgres-data:
  sonarqube-data:
  sonarqube-logs:
  sonarqube-extensions:
EOF'

# Change ownership
sudo chown -R ubuntu:ubuntu /opt/sonarqube

# Start SonarQube stack
cd /opt/sonarqube
sudo docker-compose up -d

# Wait for SonarQube to start
echo "Waiting for SonarQube to start..."
sleep 30

# Check if SonarQube is running
sudo docker-compose ps

echo "SonarQube Docker setup completed!"
echo "Access SonarQube at: http://$(hostname -I | awk '{print $1}'):9000"
echo "Default credentials - Username: admin, Password: admin"