resource "aws_internet_gateway" "smtx_iG" {
    vpc_id = aws_vpc.vpc1.id

    tags = {
      name = "Main"
    }
}

resource "aws_security_group" "smtx_sg1" {
  vpc_id = aws_vpc.vpc1.id

  ingress {

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  
}