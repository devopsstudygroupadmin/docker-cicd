#!/bin/bash
sudo yum update -y
sudo useradd sonaruser
sudo echo "sonaruser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo yum install wget unzip -y
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
sudo ulimit -n 131072
sudo ulimit -u 8192
sudo amazon-linux-extras install java-openjdk11 -y
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip
sudo unzip sonarqube-8.9.10.61524.zip
sudo mv sonarqube-8.9.10.61524 /opt/sonarqube
sudo chown -R sonaruser:sonaruser /opt/sonarqube
sudo chmod -R 775 /opt/sonarqube
sudo hostnamectl set-hostname sonarqube