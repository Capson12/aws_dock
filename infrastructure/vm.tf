resource "aws_instance" "aws_ami_image" {

    ami = "ami-0500f74cc2b89fb6b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.smtx_sub1.id
    
    tags = {
      name = "nodemachine"
    }
  
}


# resource "aws_network_interface" "smtx_nic" {
#   subnet_id = aws_subnet.smtx_sub1.id
  

#   attachment {
#     instance = aws_instance.aws_ami_image.id
#     device_index = 1
#   }
  
# }


resource "aws_eip_association" "eip1" {
  instance_id = aws_instance.aws_ami_image.id
  network_interface_id = aws_network_interface.smtx_nic.id
  allocation_id = aws_instance.aws_ami_image.id
  
  

  
}