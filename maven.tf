# launch the ec2 instance and install website
resource "aws_instance" "maven-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default-az1.id
  vpc_security_group_ids = [aws_security_group.maven-security-group.id]
  key_name               = "mobaxt_key"

  tags = {
    Name = "maven-instance"
  }
}

# an empty resource block
resource "null_resource" "maven" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/louis/DevOps/mobaxt_key.pem")
    host        = aws_instance.maven-instance.public_ip
  }

  # copy the install_jenkins.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install-java.sh"
    destination = "/tmp/install-java.sh"
  }

  provisioner "file" {
    source      = "install-maven.sh"
    destination = "/tmp/install-maven.sh"
  }

  # set permissions and run the files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-java.sh",
      "sudo chmod +x /tmp/install-maven.sh",
      "sudo sh /tmp/install-java.sh",
      "sudo sh /tmp/install-maven.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.maven-instance]
}
