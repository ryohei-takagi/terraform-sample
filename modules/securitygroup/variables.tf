variable "name" {}
variable "vpc_id" {}
variable "port" {}

variable "cider_blocks" {
  type = list(string)
}