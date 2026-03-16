#!/bin/bash
set -e

############################
# VARIABLES
############################
ARTIFACTORY_VERSION="7.55.6"     # Change version here
HOSTNAME="jfrog.madeofmemories.in"
INSTALL_DIR="/opt/jfrog"

############################
# SET HOSTNAME
############################
hostnamectl set-hostname ${HOSTNAME}
echo "$(hostname -I | awk '{print $1}') ${HOSTNAME}" >> /etc/hosts

############################
# UPDATE & INSTALL PACKAGES
############################
apt update -y
apt install -y openjdk-17-jdk curl wget unzip vim git tree

############################
# VERIFY JAVA
############################
java -version

# Backup the Environment File
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"

# Configure Environment Variables
echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/" >> /etc/environment

# Create Environment Variables
echo "JFROG_HOME=/opt/jfrog" >> /etc/environment

# Compile the Configuration
source /etc/environment

############################
# CREATE JFROG USER
############################
useradd -r -m -U -d ${INSTALL_DIR} -s /bin/false jfrog || true

############################
# CREATE INSTALL DIRECTORY
############################
mkdir -p ${INSTALL_DIR}
cd /opt

############################
# DOWNLOAD ARTIFACTORY
############################
wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/${ARTIFACTORY_VERSION}/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-linux.tar.gz

############################
# EXTRACT
############################
tar -xvzf jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-linux.tar.gz
mv artifactory-oss-${ARTIFACTORY_VERSION} ${INSTALL_DIR}

# Delete a file that is no longer needed
rm -rf /opt/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-linux.tar.gz

############################
# SET PERMISSIONS
############################
chown -R jfrog:jfrog ${INSTALL_DIR}
chmod -R 755 ${INSTALL_DIR}

############################
# CREATE SYSTEMD SERVICE
############################
cat <<EOF > /etc/systemd/system/artifactory.service
[Unit]
Description=JFrog Artifactory Service
After=network.target

[Service]
Type=forking
User=jfrog
Group=jfrog
ExecStart=/opt/jfrog/app/bin/artifactory.sh start
ExecStop=/opt/jfrog/app/bin/artifactory.sh stop
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

############################
# ENABLE & START SERVICE
############################
systemctl daemon-reload
systemctl enable artifactory
systemctl start artifactory

############################
# DISPLAY ACCESS INFO
############################
echo "----------------------------------------"
echo "JFrog Artifactory Installed Successfully"
echo "Access URL: http://$(curl -s ifconfig.me):8081"
echo "Default User: admin"
echo "Default Password: password"
echo "----------------------------------------"
