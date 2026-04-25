#!/bin/bash
set -e

############################
# VARIABLES
############################
SONARQUBE_VERSION="10.8.0.101323"
INSTALL_DIR="/opt/sonarqube"
SONAR_USER="sonar"
DB_NAME="sonarqube"
DB_USER="sonar"
DB_PASSWORD="sonar123"

############################
# SYSTEM TUNING
############################
# Set kernel parameters for SonarQube
cat <<EOF >> /etc/sysctl.conf
vm.max_map_count=524288
fs.file-max=131072
EOF
sysctl -p

# Set ulimit
cat <<EOF >> /etc/security/limits.conf
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192
EOF

############################
# UPDATE & INSTALL PACKAGES
############################
apt update -y
apt install -y openjdk-17-jdk unzip wget postgresql postgresql-contrib

############################
# VERIFY JAVA
############################
java -version

############################
# CONFIGURE POSTGRESQL
############################
systemctl enable postgresql
systemctl start postgresql

# Create database and user
sudo -u postgres psql <<EOF
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';
CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
ALTER USER ${DB_USER} WITH SUPERUSER;
\q
EOF

############################
# CREATE SONARQUBE USER
############################
useradd -r -m -U -d ${INSTALL_DIR} -s /bin/bash ${SONAR_USER} || true

############################
# DOWNLOAD & INSTALL SONARQUBE
############################
cd /tmp
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip
unzip sonarqube-${SONARQUBE_VERSION}.zip
mv sonarqube-${SONARQUBE_VERSION} ${INSTALL_DIR}

############################
# CONFIGURE SONARQUBE
############################
# Update sonar.properties
cat <<EOF >> ${INSTALL_DIR}/conf/sonar.properties

# Database Configuration
sonar.jdbc.username=${DB_USER}
sonar.jdbc.password=${DB_PASSWORD}
sonar.jdbc.url=jdbc:postgresql://localhost:5432/${DB_NAME}

# Web Server Configuration
sonar.web.host=0.0.0.0
sonar.web.port=9000

# Path Configuration
sonar.path.data=${INSTALL_DIR}/data
sonar.path.temp=${INSTALL_DIR}/temp
EOF

############################
# SET PERMISSIONS
############################
chown -R ${SONAR_USER}:${SONAR_USER} ${INSTALL_DIR}

############################
# CREATE SYSTEMD SERVICE
############################
cat <<EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=${INSTALL_DIR}/bin/linux-x86-64/sonar.sh start
ExecStop=${INSTALL_DIR}/bin/linux-x86-64/sonar.sh stop
ExecReload=${INSTALL_DIR}/bin/linux-x86-64/sonar.sh restart
User=${SONAR_USER}
Group=${SONAR_USER}
Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

############################
# ENABLE & START SONARQUBE
############################
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube

############################
# CONFIGURE FIREWALL
############################
ufw allow 9000/tcp || true

############################
# DISPLAY ACCESS INFO
############################
sleep 30
echo "----------------------------------------"
echo "SonarQube ${SONARQUBE_VERSION} Installed Successfully"
echo "Access URL: http://$(curl -s ifconfig.me):9000"
echo "Default User: admin"
echo "Default Password: admin"
echo "Database: ${DB_NAME}"
echo "Database User: ${DB_USER}"
echo "----------------------------------------"
echo "Note: SonarQube may take 2-3 minutes to fully start"
echo "----------------------------------------"

############################
# CLEANUP
############################
rm -f /tmp/sonarqube-${SONARQUBE_VERSION}.zip
