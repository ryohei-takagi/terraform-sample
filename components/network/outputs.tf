output "sample_vpc_id" {
  value = aws_vpc.default.id
}

output "sample_vpc_public_subnet_0_id" {
  value = aws_subnet.public_0.id
}

output "sample_vpc_public_subnet_1_id" {
  value = aws_subnet.public_1.id
}

output "sample_vpc_private_subnet_0_id" {
  value = aws_subnet.private_0.id
}

output "sample_vpc_private_subnet_1_id" {
  value = aws_subnet.private_1.id
}

output "sample_vpc_cider_block" {
  value = aws_vpc.default.cidr_block
}