#!/bin/bash
sudo yum update -y
sudo useradd dockeruser
sudo echo "dockeruser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo useradd ansibleuser
sudo echo "ansibleuser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum install docker -y
sudo systemctl enable --now docker
sudo usermod -aG docker dockeruser
sudo usermod -aG docker ansibleuser
sudo mkdir /opt/docker
sudo chown -R dockeruser:dockeruser /opt/docker
sudo chmod -R 775 /opt/docker
sudo hostnamectl set-hostname docker