resource "aws_internet_gateway" "smtx_iG" {
    vpc_id = aws_vpc.vpc1.id

    tags = {
      name = "Main"
    }

  
}

# resource "aws_route" "name" {
  
# }