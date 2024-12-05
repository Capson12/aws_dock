resource "aws_internet_gateway" "smtx_iG" {
    vpc_id = aws_vpc.vpc1.id

    tags = {
      name = "Main"
    }
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc1.id
#Inbound Rules
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {

    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["10.0.2.0/24"]
  }


#Outbound Rules
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

}
