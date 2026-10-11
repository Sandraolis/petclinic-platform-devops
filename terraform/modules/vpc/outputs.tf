output "petclinic_vpc_id" {
  description = "ID of the Petclinic VPC"
  value       = aws_vpc.petclinic_vpc.id
}

output "petclinic_public_subnet_ids" {
  description = "IDs of the Petclinic public subnets"
  value       = aws_subnet.petclinic_public_subnet[*].id
}

output "petclinic_public_subnet_cidrs" {
  description = "CIDR blocks of the Petclinic public subnets"
  value       = aws_subnet.petclinic_public_subnet[*].cidr_block
}
