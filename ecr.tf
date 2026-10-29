resource "aws_ecr_account_setting" "basic_scan_type_version" {
  name  = "BASIC_SCAN_TYPE_VERSION"
  value = "AWS_NATIVE"
}

resource "aws_ecr_repository" "home-inventory" {
  name                 = "home-inventory"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "mongodb" {
  name                 = "mongodb"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "home-inventory_policy" {
  repository = aws_ecr_repository.home-inventory.name

  policy = <<EOF
{
  "rules": [
      {
      "rulePriority": 1,
      "description": "Expire untagged images older than defined days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.ecr_untagged_expiry_days}
      },
      "action": {
        "type": "expire"
      }
    },
       {
      "rulePriority": 2,
      "description": "Expire images older than defined days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.ecr_expiry_days}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "mongodb_policy" {
  repository = aws_ecr_repository.mongodb.name

  policy = <<EOF
{
  "rules": [
      {
      "rulePriority": 1,
      "description": "Expire untagged images older than defined days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.ecr_untagged_expiry_days}
      },
      "action": {
        "type": "expire"
      }
    },
       {
      "rulePriority": 2,
      "description": "Expire images older than defined days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.ecr_expiry_days}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
