#!/bin/bash

sudo apt update && sudo apt install -y openjdk-11-jre

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins

sudo systemctl status jenkins >> ~/Status.txt

# Update package lists
sudo apt-get update

# Install software-properties-common
sudo apt-get install -y software-properties-common

# Add the Dead Snakes PPA
sudo add-apt-repository -y ppa:deadsnakes/ppa

# Update package lists after adding PPA
sudo apt-get update

# Install Python 3.7 and other required packages
sudo apt-get install -y python3.7 python3.7-venv build-essential libmysqlclient-dev python3.7-dev

# Verify the installation
python3.7 --version
