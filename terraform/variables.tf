variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-northeast-3" 
}
variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
  default     = "vpc-0db52c90136db0cbe"
}
variable "public_subnets" {
  type = list(string)
  default = ["subnet-0b13a0541a668bcdf",
  "subnet-0a84dde4580ecae54"
]
  
}
variable "alb_sg" {
  description = "Security group for the Application Load Balancer"
  type        = string
  default     = "sg-03a12a6794fe937c2"
}
variable "ecs_sg" {
  description = "Security group for the Application Load Balancer"
  type        = string
  default     = "sg-03a12a6794fe937c2"

}
variable "ecs_task_exec_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
  default     = "arn:aws:iam::890742579135:role/ecsTaskExecutionRole"
}

variable "image_tag" {
  description = "The Docker image tag to use for the ECS task"
  type        = string
}




