module "ec2_key" {
  source = "../../modules/key_pair"
  public_key_file = "./ec2-${terraform.workspace}.id_rsa.pub"
  private_key_file = "./ec2-${terraform.workspace}.id_rsa"
  key_name = "ec2-${terraform.workspace}"
}

resource "aws_instance" "ec2" {
  ami = "ami-011facbea5ec0363b"
  instance_type = "t3.nano"
  availability_zone = "ap-northeast-1c"
  ebs_optimized = false
  vpc_security_group_ids = [data.terraform_remote_state.securitygroup.outputs.ec2_security_group_id]
  key_name = module.ec2_key.key_name
  subnet_id = data.terraform_remote_state.network.outputs.sample_vpc_public_subnet_0_id
  associate_public_ip_address = true

  tags = {
    Name = "sample-${terraform.workspace}"
  }
}