provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Project     = "petclinic"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}
