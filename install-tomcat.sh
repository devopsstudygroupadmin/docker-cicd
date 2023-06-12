#!/bin/bash
sudo useradd ansibleuser
sudo echo "ansibleuser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.8/bin/apache-tomcat-10.1.8.tar.gz
sudo tar -xvzf apache-tomcat-10.1.8.tar.gz
sudo mv apache-tomcat-10.1.8 /opt/tomcat
sudo chmod +x /opt/tomcat/bin/startup.sh shutdown.sh
sudo ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
sudo ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown
sudo cp /tmp/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
sudo cp /tmp/context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo cp /tmp/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
sudo rm -rf apache-tomcat-10.1.8.tar.gz
sudo hostnamectl set-hostname tomcat