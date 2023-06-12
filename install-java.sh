#!/bin/bash
sudo yum update -y
sudo yum install tree wget git -y
sudo yum install java-11* -y
sudo sed -i '6aJAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto.x86_64' /root/.bash_profile
sudo sed -i '11d' /root/.bash_profile
sudo sed -i '10aPATH=$PATH:$HOME/bin:$JAVA_HOME' /root/.bash_profile