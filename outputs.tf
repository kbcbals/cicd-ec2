

output "vpc_id"{
    value = aws_vpc.development-vpc.id
}

output "ec2-public-ip"{
    value = aws_instance.myapp-server.public_ip
}


output "az"{
    value = var.az[0]
}
output "gw_id"{
    value = aws_internet_gateway.myapp-igw.id
}

output "route_table_id"{
    value = aws_route_table.dev-routetable
}

output "sg_id"{    
    value = aws_security_group.myapp-sg.id
}


output "aws_ami_id"{
     value = data.aws_ami.ubuntu.id
}


output "ec2_id"{
    value = aws_instance.myapp-server.id
}




