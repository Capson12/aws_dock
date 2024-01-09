resource "aws_instance" "aws_ami_image" {

    ami = "ami-0500f74cc2b89fb6b"
    instance_type = "t2.micro"


    tags = {
      name = "nodemachine"
    }
  
}