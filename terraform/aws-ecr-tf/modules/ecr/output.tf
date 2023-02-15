output "repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
  description = "The url of the repository (aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
}

output "registry_id" {
  value = aws_ecr_repository.ecr_repository.registry_id
  description = "The registry id where the repository was created in aws."
}