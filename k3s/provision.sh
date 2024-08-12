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

yum update -y
yum install net-tools -y