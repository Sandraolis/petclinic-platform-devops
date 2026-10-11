resource "aws_ecr_repository" "petclinic_repositories" {
  for_each = var.service_names

  name                 = "${var.project}-${var.environment}-${each.value}"
  image_tag_mutability = var.environment == "prod" ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project}-${var.environment}-${each.value}"
  }
}
