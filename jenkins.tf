# launch the ec2 instance 
resource "aws_instance" "jenkins-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default-az1.id
  vpc_security_group_ids = [aws_security_group.jenkins-security-group.id]
  key_name               = "mobaxt_key"

  tags = {
    Name = "jenkins-instance"
  }
}

# an empty resource block
resource "null_resource" "jenkins" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/louis/DevOps/mobaxt_key.pem")
    host        = aws_instance.jenkins-instance.public_ip
  }

  # copy the files from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install-java.sh"
    destination = "/tmp/install-java.sh"
  }

  provisioner "file" {
    source      = "install-sonar-scanner.sh"
    destination = "/tmp/install-sonar-scanner.sh"
  }

  provisioner "file" {
    source      = "install-jenkins.sh"
    destination = "/tmp/install-jenkins.sh"
  }

  provisioner "file" {
    source      = "install-maven.sh"
    destination = "/tmp/install-maven.sh"
  }

  # set permissions and run the files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-java.sh",
      "sudo chmod +x /tmp/install-sonar-scanner.sh",
      "sudo chmod +x /tmp/install-jenkins.sh",
      "sudo chmod +x /tmp/install-maven.sh",
      "sudo sh /tmp/install-java.sh",
      "sudo sh /tmp/install-sonar-scanner.sh",
      "sudo sh /tmp/install-jenkins.sh",
      "sudo sh /tmp/install-maven.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.jenkins-instance]
}