provider "aws" {
  region     = "eu-west-3"
  access_key = 
  secret_key = 
}

resource "aws_ecs_cluster" "creating-basic-nodejs-app" {
  name = "basic-nodejs-app-cluster" #improve the name
}

resource "aws_ecr_repository" "creating-ecr-for-basic-nodejs-app" {
  name                 = "basic-nodejs-app-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_task_definition" "creating-task-definition-for-basic-nodejs-app" {
  family                = "basic-nodejs-app-task-definition"
  container_definitions = "${file("task-definitions/basic-nodejs-app-definition.json")}"

  volume {
    name = "basic-nodejs-app-storage"
  }
}

resource "aws_ecs_service" "basic-nodejs-app-service" {
  name            = "basic-nodejs-app-service"
  cluster         = "basic-nodejs-app-cluster"
  task_definition = "${aws_ecs_task_definition.creating-task-definition-for-basic-nodejs-app.arn}"
  # launch_type     = "FARGATE"
}
