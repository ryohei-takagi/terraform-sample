terraform {
  required_version = "= 0.12.19"
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true

    bucket = "sample-terraform"
    key    = "network/terraform.tfstate"

    profile = "sample"
  }
}