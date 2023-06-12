# launch the ec2 instance and install website
resource "aws_instance" "jfrog-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.medium"
  subnet_id              = aws_default_subnet.default-az1.id
  vpc_security_group_ids = [aws_security_group.jfrog-security-group.id]
  key_name               = "mobaxt_key"

  tags = {
    Name = "jfrog-instance"
  }
}

# an empty resource block
resource "null_resource" "jfrog" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/louis/DevOps/mobaxt_key.pem")
    host        = aws_instance.jfrog-instance.public_ip
  }

  # copy the files from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install-java.sh"
    destination = "/tmp/install-java.sh"
  }

  provisioner "file" {
    source      = "install-jfrog.sh"
    destination = "/tmp/install-jfrog.sh"
  }


  # set permissions and run the files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-java.sh",
      "sudo chmod +x /tmp/install-jfrog.sh",
      "sudo sh /tmp/install-java.sh",
      "sudo sh /tmp/install-jfrog.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.jfrog-instance]
}