resource "aws_instance" "aws_ami_image" {

    ami = "ami-0500f74cc2b89fb6b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.smtx_sub1.id
    
    network_interface {

      subnet_id = smtx_sub1.id

    }
    
    tags = {
      name = "nodemachine"
    }
  
}

resource "aws_eip_association" "eip1" {
  instance_id = aws_instance.aws_ami_image.id
  domain = "vpc"
  network_interface_id = aws_instance.aws_ami_image.id
  

  
}