# configured aws provider with proper credentials
provider "aws" {
  region    = "us-east-1"
  profile   = "april-devops-user"
}

# create default vpc if one does not exit
resource "aws_default_vpc" "default-vpc" {

  tags    = {
    Name  = "default-vpc"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available-zones" {}

# create default subnet if one does not exit
resource "aws_default_subnet" "default-az1" {
  availability_zone = data.aws_availability_zones.available-zones.names[0]

  tags   = {
    Name = "default-subnet"
  }
}

# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# use data source to get a registered ubuntu ami
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}