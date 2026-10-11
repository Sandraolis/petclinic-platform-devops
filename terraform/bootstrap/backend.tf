terraform {
  backend "s3" {
    bucket         = "petclinic-terraform-state-520235901263"
    key            = "bootstrap/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "petclinic-terraform-locks"
  }
}
