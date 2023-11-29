#configure provider east
#resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
  #profile = "Admin"
}

#configure provider west using alias
provider "aws" {
  alias      = "west"
  region     = var.region_west
  secret_key = var.secret_key
  access_key = var.access_key
}

# configure vpc east
#resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "deployment6-vpc-east" {
  cidr_block              = "10.0.0.0/16"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = var.vpc_name
  }
}


#configure subnets within vpc east
#resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets

resource "aws_subnet" "publicSubnet01" {
  vpc_id                  = aws_vpc.deployment6-vpc-east.id 
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zone_A
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.pub_subnetA_name
  }
}

# Create a subnet within the VPC east
resource "aws_subnet" "publicSubnet02" {
  vpc_id                  = aws_vpc.deployment6-vpc-east.id 
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone_B
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.pub_subnetB_name
  }
}

# Create instance to configure application1 server east
# resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "applicationServer01-east" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.publicSubnet01.id
  security_groups = [aws_security_group.sshAcessSG.id]
  user_data = "${file("server_setup.sh")}"
  key_name = var.key_name

  
  tags = {
    "Name" : var.instance_A_name
  }

}

# Create instance to configure application2 server east
# resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "applicationServer02-east" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.publicSubnet02.id
  security_groups = [aws_security_group.sshAcessSG.id]
  user_data = "${file("server_setup.sh")}"
  key_name = var.key_name

  tags = {
    "Name" : var.instance_B_name
  }

}

# Create Security Groups for application 1 instance east

resource "aws_security_group" "sshAcessSG" {
  name        = "sshAcessSG"
  description = "open ssh traffic"
  vpc_id = aws_vpc.deployment6-vpc-east.id 


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.security_groups_name
    "Terraform" : "true"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.deployment6-vpc-east.id 

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "dp6_route_table" {
  vpc_id = aws_vpc.deployment6-vpc-east.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# associate route table with subnets east
resource "aws_route_table_association" "dp6_RT_publicSubnet01" {
  subnet_id      = aws_subnet.publicSubnet01.id
  route_table_id = aws_route_table.dp6_route_table.id
}

resource "aws_route_table_association" "dp6_RT_publicSubnet02" {
  subnet_id      = aws_subnet.publicSubnet02.id
  route_table_id = aws_route_table.dp6_route_table.id
}


#The following defines west resources

# configure vpc
#resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "deployment6-vpc-west" {
  cidr_block              = "10.0.0.0/16"
  provider                = aws.west
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = var.vpc_name_west
  }
}


#configure subnets within vpc
#resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets

resource "aws_subnet" "publicSubnet03" {
  vpc_id                  = aws_vpc.deployment6-vpc-west.id 
  cidr_block              = "10.0.2.0/24"
  provider                = aws.west
  availability_zone       = var.availability_zone_A_west
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.pub_subnetA_name_west
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "publicSubnet04" {
  vpc_id                  = aws_vpc.deployment6-vpc-west.id 
  cidr_block              = "10.0.1.0/24"
  provider                = aws.west
  availability_zone       = var.availability_zone_B_west
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.pub_subnetB_name_west
  }
}

# Create instance to configure application1 server
# resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "applicationServer01-west" {
  ami = var.ami_west
  instance_type = var.instance_type_west
  provider                = aws.west
  subnet_id = aws_subnet.publicSubnet03.id
  security_groups = [aws_security_group.sshAcessSGWest.id]
  key_name = var.key_name_west
  user_data = "${file("server_setup.sh")}"

  
  tags = {
    "Name" : var.instance_A_name_west
  }

}

# Create instance to configure application2 server
# resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "applicationServer02-west" {
  ami = var.ami_west
  instance_type = var.instance_type_west
  provider                = aws.west
  subnet_id = aws_subnet.publicSubnet04.id
  security_groups = [aws_security_group.sshAcessSGWest.id]
  key_name = var.key_name_west
  user_data = "${file("server_setup.sh")}"

  tags = {
    "Name" : var.instance_B_name_west
  }

}



# Create Security Groups for application 1 instance
resource "aws_security_group" "sshAcessSGWest" {
  name        = "sshAcessSGWest"
  provider                = aws.west
  description = "open ssh traffic"
  vpc_id = aws_vpc.deployment6-vpc-west.id 


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.security_groups_name
    "Terraform" : "true"
  }

}

resource "aws_internet_gateway" "igw-west" {
  vpc_id = aws_vpc.deployment6-vpc-west.id 
  provider                = aws.west

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "dp6_route_table-west" {
  vpc_id = aws_vpc.deployment6-vpc-west.id 
  provider                = aws.west

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-west.id
  }

  tags = {
    Name = var.route_table_name_west
  }
}

# associate route table with subnets
resource "aws_route_table_association" "dp6_RT_publicSubnet03" {
  subnet_id      = aws_subnet.publicSubnet03.id
  provider                = aws.west
  route_table_id = aws_route_table.dp6_route_table-west.id
}

resource "aws_route_table_association" "dp6_RT_publicSubnet04" {
  subnet_id      = aws_subnet.publicSubnet04.id
  provider                = aws.west
  route_table_id = aws_route_table.dp6_route_table-west.id
}
