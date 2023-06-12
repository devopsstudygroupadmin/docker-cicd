#!/bin/bash
sudo useradd ansibleuser
sudo echo "ansibleuser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo amazon-linux-extras install ansible2 -y
sudo yum install docker -y
sudo systemctl enable --now docker
sudo usermod -aG docker ansibleuser
sudo mkdir /opt/docker
sudo mv /tmp/tomcat-users.xml /opt/docker/tomcat-users.xml
sudo chown -R ansibleuser:ansibleuser /opt/docker
sudo chmod -R 775 /opt/docker
sudo hostnamectl set-hostname ansible
