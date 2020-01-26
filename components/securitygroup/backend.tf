terraform {
  required_version = "= 0.12.19"
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true

    bucket = "sample-terraform"
    key    = "securitygroup/terraform.tfstate"

    profile = "sample"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "sample-terraform"
    key    = "env:/${terraform.workspace}/network/terraform.tfstate"
    region = "ap-northeast-1"

    profile = "sample"
  }
}