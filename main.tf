 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = var.regions[0] # eu-west-2
}

# Create a VPC
resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block 
  tags ={
      Name : "development-vpc"
  }
}


# Create a subnet1
resource "aws_subnet" "dev-subnet-1"{
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone=var.az[0]
  tags = {
    Name : "Public_subnet" 
  }
}

# Create a subnet2
resource "aws_subnet" "dev-subnet-2"{
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.cidr_blocks[2].cidr_block # private
  availability_zone=var.az[0] # eu-west-2a
  tags = {
    Name : "Private_subnet"
  }
}


#create the internet gateway
resource "aws_internet_gateway" "myapp-igw"{
    vpc_id = aws_vpc.development-vpc.id

    tags = {
      Name = "myapp-igw"
    }  
}




# create the route table
resource "aws_route_table" "dev-routetable" {
  vpc_id = aws_vpc.development-vpc.id

route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
      Name = "myapp-subnet1-route-table"
  }
}

resource "aws_route_table_association" "myapp-rtb-public-subnet" {
  subnet_id =  aws_subnet.dev-subnet-1.id
  route_table_id = aws_route_table.dev-routetable.id
}

/*
                ssh keypair

*/
resource "aws_key_pair" "ssh-key" {
    key_name = "circleci"
    public_key = file(var.public_key_location)
}

resource "aws_security_group" "myapp-sg"{
  name = "myapp_sg"
  vpc_id = aws_vpc.development-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.myip_ubuntu]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #allow any traffic
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = []
  }

  tags = {
      Name = "myapp-sg"
  }
}

# create the ec2 instance
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id =  aws_subnet.dev-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]

  availability_zone=var.az[0]

  associate_public_ip_address = true
  
  key_name = aws_key_pair.ssh-key.key_name
  
  user_data = file(var.entry_script)


# this is the public key and not private key
# which is shared always
  connection {
    type     = "ssh"
    host     =  self.public_ip # var.myip_ubuntu
    user     = "ubuntu"    
    /* private_key     = file(var.public_key_location) */
    private_key     = file(var.key_location)
  }
 
  provisioner "file" {
    source      = "./deploy/templates/ec2-caller.sh"
    destination = "/home/ubuntu/ec2-caller.sh"
  }
   
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/ec2-caller.sh",      
    ]
  }

  tags = {
      Name = "cicd-trigger-machine"
  }
} 


