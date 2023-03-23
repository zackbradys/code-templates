resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  force_delete = var.force_delete
  
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  count = var.expiration_after_days > 0 ? 1 : 0
  repository = aws_ecr_repository.ecr_repository.name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.expiration_after_days} days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.expiration_after_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}