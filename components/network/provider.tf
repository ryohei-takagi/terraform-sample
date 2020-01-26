variable "profile" {
  default = "sample"
}

provider "aws" {
  version = "= 2.45.0"
  region  = "ap-northeast-1"
  profile = var.profile
}