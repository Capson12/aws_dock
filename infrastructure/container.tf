module "ecs" {
    source = "terraform-aws-modules/ecs/aws"
    version = "5.11.4"

    cluster_name = "DevCluster"
    

    default_capacity_provider_use_fargate = false
    autoscaling_capacity_providers = {
        ex_1 = {
            auto_scaling_group_arn = module.autoscaling["ex_1"].autoscaling_group_arn

            managed_scaling = {
                maximum_scaling_step_size = 5
                minimum_scaling_step_size = 1
                status = "ENABLED"
                target_capacity = 60
            }

            default_capacity_provider_strategy = {
                weight = 60
                base = 20
            }
        }

    }
}



# Suppoting info
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "loader2011"

  load_balancer_type = "application"

  vpc_id  = aws_vpc.vpc1.id
  subnets = [aws_subnet.smtx_sub1.id, aws_subnet.smtx_sub2.id]

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = aws_subnet.smtx_sub1.cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "ex_ecs"
      }
    }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # Theres nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

  
}

module "autoscaling" {
    source = "terraform-aws-modules/autoscaling/aws"
    version = "~> 6.5"
    image_id = "ami-0abb41dc69b6b6704"

    for_each = {
      ex_1 = {
      instance_type = "t3.micro"
      use_mixed_instances_policy = false
      mixed_instances_policy = {}
      }
    }


    name = "alb_smtx"
    instance_type = "t3.micro"
    security_groups = [aws_default_security_group.default.id]
    min_size = 1
    max_size = 3
    #availability_zones = [aws_subnet.smtx_sub2.availability_zone, aws_subnet.smtx_sub1.availability_zone]
    vpc_zone_identifier = [aws_subnet.smtx_sub1.id, aws_subnet.smtx_sub2.id]
  
}
