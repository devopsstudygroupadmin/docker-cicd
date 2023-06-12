# launch the ec2 instance 
resource "aws_instance" "docker-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default-az1.id
  vpc_security_group_ids = [aws_security_group.docker-security-group.id]
  key_name               = "mobaxt_key"

  tags = {
    Name = "docker-instance"
  }
}

# an empty resource block
resource "null_resource" "docker" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/louis/DevOps/mobaxt_key.pem")
    host        = aws_instance.docker-instance.public_ip
  }

  # copy the files from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install-docker.sh"
    destination = "/tmp/install-docker.sh"
  }

  # set permissions and run the files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-docker.sh",
      "sudo sh /tmp/install-docker.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.docker-instance]
}
