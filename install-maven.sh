#!/bin/bash
sudo useradd jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.2/binaries/apache-maven-3.9.2-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.2-bin.tar.gz
sudo mv apache-maven-3.9.2 /opt/maven
sudo sed -i '11d' /root/.bash_profile
sudo sed -i '7aM2_HOME=/opt/maven' /root/.bash_profile
sudo sed -i '8aM2=$M2_HOME/bin' /root/.bash_profile
sudo sed -i '12aPATH=$PATH:$HOME/bin:$JAVA_HOME:$M2_HOME:$M2' /root/.bash_profile
sudo hostnamectl set-hostname maven