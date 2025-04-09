# # key pair (login)

# resource aws_key_pair my_key {
#   key_name = "terra-key-ec2"
#   public_key = file("terra-key-ec2.pub")

# }

# #  VPC & Security Group

# resource aws_default_vpc default {

# }

# resource aws_security_group my_security_group {
#     name = "automate-sg"
#     description = "this will add a TF generated security group"
#     vpc_id = aws_default_vpc.default.id # interpolation\

#     # inbound rules

#     ingress {
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         description = "SSH open"
#     }
#     ingress {
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         description = "HTTP open"
#     }
#     ingress {
#         from_port   = 8000
#         to_port     = 8000
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         description = "Flask app"
#     }


#     # outbound rules

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#         description = "all traffic allowed"
#     }

#     tags = {
#         Name = "automate-sg"
#     }
# }

# # EC2 instance

# resource aws_instance my_instance {
#     key_name      = aws_key_pair.my_key.key_name
#     security_groups = [aws_security_group.my_security_group.name]
#     instance_type = "t2.micro"
#     ami           = "ami-04f167a56786e4b09" # ubuntu

#     root_block_device {
#       volume_size = 15
#       volume_type = "gp3"
#     }
#     tags = {
#         Name = "vishal-talaviya"
#     }
# }




/************************************************  using variables ec2.tf  *************************************/


# key pair (login)

resource aws_key_pair my_key {
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")

}

#  VPC & Security Group

resource aws_default_vpc default {

}

resource aws_security_group my_security_group {
    name = "automate-sg"
    description = "this will add a TF generated security group"
    vpc_id = aws_default_vpc.default.id # interpolation\

    # inbound rules

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Flask app"
    }


    # outbound rules

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all traffic allowed"
    }

    tags = {
        Name = "automate-sg"
    }
}

# EC2 instance

resource aws_instance my_instance {
    for_each = tomap({
        vishal1 = "t2.micro",
        vishal2 = "t2.micro"
    }) #meta argument

    depends_on = [ aws_security_group.my_security_group, aws_key_pair.my_key ]

    key_name      = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = each.value
    ami           = var.ec2_ami_id # ubuntu
    user_data = file("install_nginx.sh")

    root_block_device {
      volume_size = var.env == "prd" ? 20 : var.ec2_root_storage_size
      volume_type = "gp3"
    }
    tags = {
        Name = each.key
    }
}

# for a "terraform import"

# resource "aws_instance" "my_new_instacne" {
#   ami = "unknown"
#   instance_type = "unknown"
# }