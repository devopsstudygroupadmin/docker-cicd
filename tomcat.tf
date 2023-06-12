# launch the ec2 instance and install website
resource "aws_instance" "tomcat-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default-az1.id
  vpc_security_group_ids = [aws_security_group.tomcat-security-group.id]
  key_name               = "mobaxt_key"

  tags = {
    Name = "tomcat-instance"
  }
}

# an empty resource block
resource "null_resource" "tomcat" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/louis/DevOps/mobaxt_key.pem")
    host        = aws_instance.tomcat-instance.public_ip
  }

  # copy the files from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install-java.sh"
    destination = "/tmp/install-java.sh"
  }

  provisioner "file" {
    source      = "context.xml"
    destination = "/tmp/context.xml"
  }

  provisioner "file" {
    source      = "tomcat-users.xml"
    destination = "/tmp/tomcat-users.xml"
  }

  provisioner "file" {
    source      = "install-tomcat.sh"
    destination = "/tmp/install-tomcat.sh"
  }


  # set permissions and run the files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-java.sh",
      "sudo chmod +x /tmp/install-tomcat.sh",
      "sudo sh /tmp/install-java.sh",
      "sudo sh /tmp/install-tomcat.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.tomcat-instance]
}
