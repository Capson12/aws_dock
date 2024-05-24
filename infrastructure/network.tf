resource "aws_internet_gateway" "smtx_iG" {
    vpc_id = aws_vpc.vpc1.id

    tags = {
      name = "Main"
    }
}

/*resource "aws_security_group" "smtx_sg1" {
  vpc_id = aws_vpc.vpc1.id

  ingress {

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress = {

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  
  }

  
}
*/
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

    protocol =  "tcp"
    self = true
    from_port = 22
    to_port = 22
  }

    ingress {

    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_block = ["0.0.0.0/0"]
  }


#Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
