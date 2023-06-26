resource "aws_ecr_repository" "aws_ecr_repository" {
  for_each = var.name
  name                  = each.value

  image_tag_mutability  = var.image_tag_mutability
  force_delete          = var.force_delete

  image_scanning_configuration {
    scan_on_push        = var.scan_on_push
  }  
}

resource "aws_ecr_lifecycle_policy" "aws_ecr_policy" {
  for_each             = var.name
  repository           = aws_ecr_repository.aws_ecr_repository[each.key].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.expiration_after_days} days.",
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