## Terraform Sample

- Create VPC, SecurityGroup, EC2, Aurora.

## Example

```
$ cd ./components/network
$ terraform init
$ terraform workspace new staging
$ terraform workspace new production
$ terraform workspace select staging
$ terraform plan
$ terraform apply
```