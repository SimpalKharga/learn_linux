terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.33.0"
        }
    }
}

provider "aws" {
    # configuration options
}

resource "aws_key_pair" "sim_ssh_key" {
  key_name   = var.SSH_KEY_NAME
  public_key = var.SSH_PUB_KEY
}  

resource "aws_instance" "terraform_inst" {
  ami           = var.AMI_ID
  instance_type = var.INST_TYPE
  tags = {
    Name = var.EC2_TAG
  }
  key_name = aws_key_pair.sim_ssh_key.key_name
  security_groups = [aws_security_group.sim_terra_sg.name]

}

resource "aws_security_group" "sim_terra_sg" {
    name = var.SG_NAME

 ingress {
    from_port  = var.HTTP_PORT   
    to_port    = var.HTTP_PORT
    protocol   = "tcp"
    cidr_blocks = [var.CIDR_RANGE]
  }

 ingress {
    from_port  = var.HTTPS_PORT   
    to_port    = var.HTTPS_PORT
    protocol   = "tcp"
    cidr_blocks = [var.CIDR_RANGE]

  }

}

 