# east variables
aws_access_key          = ""
aws_secret_key          = "" 
region              = "us-east-1"
ami                 = "ami-0fc5d935ebf8bc3bc"
instance_type       = "t2.large"
vpc_name            = "deployment6-vpc-east"
availability_zone_A = "us-east-1b"
availability_zone_B = "us-east-1c"
pub_subnetA_name    = "publicSubnet01"
pub_subnetB_name    = "publicSubnet02"
key_name            = "Deploy4Key"
instance_A_name     = "applicationServer01-east"
instance_B_name     = "applicationServer02-east"
security_groups_name = "sshAcessSG"
igw_name             = "igw"
route_table_name     = "d6_1RT"

#west variables
region_west              = "us-west-2"
ami_west                 = "ami-0efcece6bed30fd98"
instance_type_west       = "t2.large"
vpc_name_west            = "deployment6-vpc-west"
availability_zone_A_west = "us-west-2a"
availability_zone_B_west = "us-west-2b"
pub_subnetA_name_west    = "publicSubnet03"
pub_subnetB_name_west    = "publicSubnet04"
instance_A_name_west     = "applicationServer01-west"
instance_B_name_west     = "applicationServer02-west"
key_name_west            = "d6_west"
igw_name_west            = "igw-west"
route_table_name_west    = "d6_1RTWest"
