
################################################################################
# Cluster
################################################################################


module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = "DevCluster"
  default_capacity_provider_use_fargate = false
  
  autoscaling_capacity_providers = {
    ex_1 = {
      auto_scaling_group_arn = module.autoscaling["ex_1"].autoscaling_group_arn
      
      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        status = "ENABLED"
        target_capacity = 60
      }
        
        default_capacity_provider_strategy = {
          weight = 1
          base = 0
        }
    }
  }
    
}


################################################################################
# Service
################################################################################

module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name = "service"
  cluster_arn = module.ecs.cluster_arn

  create_task_definition = false
  requires_compatibilities = ["EC2"]
  
  task_definition_arn = "arn:aws:ecs:eu-west-2:117971648125:task-definition/smtx-rual-cv:1"
  subnet_ids = [aws_subnet.smtx_sub1.id, aws_subnet.smtx_sub2.id]
  create_security_group = false
  security_group_ids = [aws_default_security_group.default.id]

  #launch_type = "EC2"
  capacity_provider_strategy = {
    ex_1 = {
      capacity_provider = module.ecs.autoscaling_capacity_providers["ex_1"].name
      weight = 1
      base = 0
    }
  }
 
  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name = "cv_app"
      container_port = 80
    }
  }

  
}



################################################################################
# Supporting Resources
################################################################################


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "loader2011"

  load_balancer_type = "application"

  vpc_id  = aws_vpc.vpc1.id
  subnets = [aws_subnet.smtx_sub1.id, aws_subnet.smtx_sub2.id]

  # For example only
  enable_deletion_protection = false

  create_security_group = false
  security_groups = [ aws_default_security_group.default.id ]

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
    image_id = "ami-083875b2e7198adf0"
    

    for_each = {
      ex_1 = {
        instance_type = "t3.medium"
        use_mixed_instances_policy = false
        mixed_instances_policy = {}
        user_data                  = <<-EOT
          #!/bin/bash


          cat <<'EOF' >> /etc/ecs/ecs.config
          ECS_CLUSTER=DevCluster
          EOF
        
        EOT
      }
    }

    create_iam_instance_profile = true

    name = "asg_smtx"
    instance_type = "t3.medium"
    security_groups = [aws_default_security_group.default.id]
    min_size = 0
    max_size = 1
    desired_capacity = 1
    vpc_zone_identifier = [aws_subnet.smtx_sub1.id, aws_subnet.smtx_sub2.id]
    user_data = base64encode(each.value.user_data)


    iam_role_name = "asg_role"
    iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    key = "AmazonECSManaged"
    ECSClusterName = "DevCluster"
  }
  
}



output "ecs_capacity_provider_name" {
  value = module.ecs.autoscaling_capacity_providers["ex_1"].name
}
