# Define the AWS provider configuration
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Adjust the CIDR block to your requirements
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a public subnet within the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"  # Adjust the CIDR block to your requirements
  availability_zone = "us-east-1a"  # Adjust to your desired availability zone
  map_public_ip_on_launch = true  # This allows instances in this subnet to have public IPs
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a Route Table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a Route in the public Route Table to route traffic to the Internet Gateway
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"  # Route all traffic
  gateway_id = aws_internet_gateway.my_igw.id
}

# Associate the public Route Table with the public subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a private subnet within the VPC
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # Adjust the CIDR block to your requirements
  availability_zone = "us-east-1b"  # Adjust to your desired availability zone
}

# Create a NAT Gateway in the public subnet
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Allocate an Elastic IP (EIP) for the NAT Gateway
resource "aws_eip" "my_eip" {}

# Create a Route Table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a Route in the private Route Table to route traffic to the NAT Gateway
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"  # Route all traffic
  nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
}

# Associate the private Route Table with the private subnet
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create a security group for both EC2 instances
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow incoming SSH and outgoing traffic"
  
  # Define security group rules (modify as needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For SSH access
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Launch an EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (adjust as needed)
  instance_type = "t2.micro"  # Adjust to your desired instance type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.my_security_group.id]
  key_name      = "your-key-pair"  # Modify with your SSH key pair
  associate_public_ip_address = true

  # Add user data to run custom scripts on the instance if needed
  user_data = <<-EOF
              #!/bin/bash
              # Your initialization script here
              EOF
}

# Launch an EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (adjust as needed)
  instance_type = "t2.micro"  # Adjust to your desired instance type
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.my_security_group.id]
  key_name      = "your-key-pair"  # Modify with your SSH key pair

  # Add user data to run custom scripts on the instance if needed
  user_data = <<-EOF
              #!/bin/bash
              # Your initialization script here
              EOF
}
