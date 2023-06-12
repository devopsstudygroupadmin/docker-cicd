# create security group for the maven instances
resource "aws_security_group" "maven-security-group" {
  name        = "maven-security-group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on port 22 all over the internet
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "maven-security-group"
  }
}

# create security group for the tomcat instances
resource "aws_security_group" "tomcat-security-group" {
  name        = "tomcat-security-group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on port 22 all over the internet
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 8080 - 8090 all over the internet
  ingress {
    description      = "http access"
    from_port        = 8080
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "tomcat-security-group"
  }
}

# create security group for the jfrog instances
resource "aws_security_group" "jfrog-security-group" {
  name        = "jfrog-security-group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on port 22 all over the internet
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 8080 - 8090 all over the internet
  ingress {
    description      = "http access"
    from_port        = 8081
    to_port          = 8082
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "jfrog-security-group"
  }
}

# create security group for the sonarqube instances
resource "aws_security_group" "sonarqube-security-group" {
  name        = "sonarqube-security-group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on port 22 all over the internet
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 8080 - 8090 all over the internet
  ingress {
    description      = "http access"
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "sonarqube-security-group"
  }
}

# create security group for the jenkins instances
resource "aws_security_group" "jenkins-security-group" {
  name        = "jenkins-security-group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on port 22 all over the internet
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 8080 all over the internet
  ingress {
    description      = "http access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "jenkins-security-group"
  }
}

# create security group for the ansible instances
resource "aws_security_group" "ansible-security-group" {
  name        = "ansible-security-group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on port 22 all over the internet
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ansible-security-group"
  }
}

# create security group for the docker instances
resource "aws_security_group" "docker-security-group" {
  name        = "docker-security-group"
  description = "allow access on all port"
  vpc_id      = aws_default_vpc.default-vpc.id

  # allow access on all port 
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "docker-security-group"
  }
}

