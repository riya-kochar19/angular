output "ecr_repository_url" {
  value = aws_ecr_repository.my_app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

