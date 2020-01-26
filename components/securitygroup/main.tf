module "ec2" {
  source = "../../modules/securitygroup"
  name = "ec2-sg-${terraform.workspace}"
  vpc_id = data.terraform_remote_state.network.outputs.sample_vpc_id
  port = 22
  cider_blocks = var.ec2_access_ip
}