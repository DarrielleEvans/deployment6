# east
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}
variable "instance_type" {}
variable "vpc_name" {}
variable "availability_zone_A" {}
variable "availability_zone_B" {}
variable "pub_subnetA_name" {}
variable "pub_subnetB_name" {}
variable "key_name" {}
variable "instance_A_name" {}
variable "instance_B_name" {}
variable "security_groups_name" {}
variable "igw_name" {}
variable "route_table_name" {}
variable "ami" {}

# west
variable "region_west" {}
variable "ami_west" {}
variable "instance_type_west" {}
variable "vpc_name_west" {}
variable "availability_zone_A_west" {}
variable "availability_zone_B_west" {}
variable "pub_subnetA_name_west" {}
variable "pub_subnetB_name_west" {}
variable "instance_A_name_west" {}
variable "instance_B_name_west" {}
variable "igw_name_west" {}
variable "route_table_name_west" {}
variable "key_name_west" {}
