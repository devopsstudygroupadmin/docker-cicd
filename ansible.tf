# launch the ec2 instance 
resource "aws_instance" "ansible-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default-az1.id
  vpc_security_group_ids = [aws_security_group.ansible-security-group.id]
  key_name               = "mobaxt_key"

  tags = {
    Name = "ansible-instance"
  }
}

# an empty resource block
resource "null_resource" "ansible" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/louis/DevOps/mobaxt_key.pem")
    host        = aws_instance.ansible-instance.public_ip
  }

  # copy the files from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install-ansible.sh"
    destination = "/tmp/install-ansible.sh"
  }

  provisioner "file" {
    source      = "tomcat-users.xml"
    destination = "/tmp/tomcat-users.xml"
  }

  # set permissions and run the files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-ansible.sh",
      "sudo sh /tmp/install-ansible.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.ansible-instance]
}
