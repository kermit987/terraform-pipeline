variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}

provider "aws" {
  region     = "eu-west-3"
  access_key = var.ACCESS_KEY
  secret_key = var.SECRET_KEY
}

resource "aws_ecs_cluster" "creating-basic-nodejs-app" {
  name = "basic-nodejs-app-cluster" #improve the name
}

# resource "aws_ecs_capacity_provider" "test-provider" {
#   name = "basic-nodejs-app-capacity-provider"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = "aws_autoscaling_group.test-provider.arn"
#   }
# }

resource "aws_ecr_repository" "creating-ecr-for-basic-nodejs-app" {
  name                 = "basic-nodejs-app-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_task_definition" "creating-task-definition-for-basic-nodejs-app" {
  family                = "basic-nodejs-app-task-definition"
  container_definitions = file("task-definitions/basic-nodejs-app-definition.json")

  volume {
    name = "basic-nodejs-app-storage"
  }
}
resource "aws_ecs_service" "basic-nodejs-app-service" {
  name            = "basic-nodejs-app-service"
  cluster         = "basic-nodejs-app-cluster"
  task_definition = aws_ecs_task_definition.creating-task-definition-for-basic-nodejs-app.arn
  # default_capacity_provider_strategy {
  #   capacity_provider
  # }
  # launch_type     = "FARGATE"
}

# resource "aws_placement_group" "basic-nodejs-app-service-group" {
#   name = "test"
#   strategy = "cluster"
# }

# resource "aws_autoscaling_group" "basic-nodejs-app-service-group" {
#   name = "basic-nodejs-app-service-group"
#     max_size                  = 5
#   min_size                  = 2

# }
