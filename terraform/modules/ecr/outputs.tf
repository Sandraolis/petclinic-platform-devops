output "petclinic_ecr_repository_urls" {
  description = "ECR repository URLs indexed by microservice name."

  value = {
    for service, repository in aws_ecr_repository.petclinic_repositories :
    service => repository.repository_url
  }
}
