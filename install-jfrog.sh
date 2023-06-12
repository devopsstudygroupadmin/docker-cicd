#!/bin/bash
sudo wget https://jfrog.bintray.com/artifactory/jfrog-artifactory-oss-6.9.6.zip
sudo unzip jfrog-artifactory-oss-6.9.6.zip
sudo mv artifactory-oss-6.9.6 /opt/jfrog
sudo rm -rf jfrog-artifactory-oss-6.9.6.zip
sudo hostnamectl set-hostname jfrog