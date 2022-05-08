 regions=["eu-west-2","eu-west-3"]
 az=["eu-west-2a","eu-west-2b","eu-west-2c"]
 
 cidr_blocks=[
     { cidr_block = "10.0.0.0/16",name = "dev-vpc" }, # vpc 
     { cidr_block = "10.0.10.0/24",name = "dev-subnet-1"}, # subnet 1
     { cidr_block = "10.0.20.0/24",name = "dev-subnet-2"} # subnet 2
 ]
myip_ubuntu = "90.246.79.204/32"
instance_type = "t2.micro"

public_key_location = "./deploy/templates/circleci1.pub"
/* key_location = "/home/balab/.ssh/circleci" */
entry_script = "./deploy/templates/user-data.sh"
/* EC2_PVT_KEY = "" */
 
 
 