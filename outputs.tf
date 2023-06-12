# print the public IP of the maven server
output "maven_instance_ip_addr" {
  value       = aws_instance.maven-instance.public_ip
  description = "The public IP address of the maven server instance."
}

# print the public IP of the tomcat server
output "tomcat_instance_ip_addr" {
  value       = aws_instance.tomcat-instance.public_ip
  description = "The public IP address of the tomcat server instance."
}

# print the public IP of the jfrog server
output "jfrog_instance_ip_addr" {
  value       = aws_instance.jfrog-instance.public_ip
  description = "The public IP address of the jfrog server instance."
}

# print the public IP of the sonarqube server
output "sonarqube_instance_ip_addr" {
  value       = aws_instance.sonarqube-instance.public_ip
  description = "The public IP address of the sonarqube server instance."
}

# print the public IP of the jenkins server
output "jenkins_instance_ip_addr" {
  value       = aws_instance.jenkins-instance.public_ip
  description = "The public IP address of the jenkins server instance."
}

# print the public IP of the ansible server
output "ansible_instance_ip_addr" {
  value       = aws_instance.ansible-instance.public_ip
  description = "The public IP address of the ansible server instance."
}

# print the public IP of the docker server
output "docker_instance_ip_addr" {
  value       = aws_instance.docker-instance.public_ip
  description = "The public IP address of the docker server instance."
}


# print the url of the jenkins server
output "jenkins_website_url" {
  value     = join ("", ["http://", aws_instance.jenkins-instance.public_dns, ":", "8080"])
}

# print the url of the jfrog server
output "jfrog_website_url" {
  value     = join ("", ["http://", aws_instance.jfrog-instance.public_dns, ":", "8081"])
}

# print the url of the tomcat server
output "tomcat_website_url" {
  value     = join ("", ["http://", aws_instance.tomcat-instance.public_dns, ":", "8080"])
}

# print the url of the sonarqube server
output "sonarqube_website_url" {
  value     = join ("", ["http://", aws_instance.sonarqube-instance.public_dns, ":", "9000"])
}