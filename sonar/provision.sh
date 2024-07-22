#!/bin/bash

##########################################################################

# Set DNS manually
echo "Setting DNS..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Update system and install necessary packages
echo "Updating system and installing necessary packages..."
dnf clean all
dnf makecache
dnf -y update

# Fix repository issues by updating the base URL
echo "Fixing repository issues..."
sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*
sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update repositories and install httpd
echo "Installing Apache HTTP server..."
dnf -y update
dnf -y install httpd

# Enable and start httpd service
echo "Enabling and starting httpd service..."
systemctl enable httpd
systemctl start httpd
##########################################################################

useradd sonar
yum update -y
yum install wget java-11-openjdk-devel unzip -y

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip

unzip sonarqube-9.1.0.47736.zip -d /opt/

mv /opt/sonarqube-9.1.0.47736/ /opt/sonarqube

chown -R sonar:sonar /opt/sonarqube

touch /etc/systemd/system/sonar.service
echo > /etc/systemd/system/sonar.service
cat <<EOT >> /etc/systemd/system/sonar.service
[Unit]
Description=Sonarqube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
[Install]
WantedBy=multi-user.targvet
EOT

sudo systemctl daemon-reload

service sonar start


#Install sonar scanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/
mv /opt/sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner
chown -R sonar:sonar /opt/sonar-scanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile


#install nodejs
curl –sL https://rpm.nodesource.com/setup_10.x | sudo bash -

sudo yum install –y nodejs