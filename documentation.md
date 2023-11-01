# Purpose
    
# Issues
- When I created the instances using Terraform, I used an incorrect AMI that installed Linux. I used the command "terraform destroy" to delete the configured resources. This allowed me to put the correct AMI ID in the tfvars file and create the instances with Ubuntu.
- When running the Jenkins build, the test stage failed with the error:
  "E   MySQLdb.OperationalError: (2003, "Can't connect to MySQL server on 'mydatabase.cczam3a4yemt.us-east-1.rds.amazonaws.com:3306' (110)") ".
  * The port "3306" was not opened. Once I edited the inbound rules in security. The test stage passed successfully.
# Steps
### Step 1
* Use Terraform to create two instances to create a Jenkins server and agent architecture.
  - Install on the Jenkins Server
  - Install on the Jenkins Agent
* 
# System Diagram

# Optimization (How would make this deployment more efficient)
* I manually installed the following dependencies:
  Instance 1:
    - Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev,         python3.7-dev
  Instance 2:
    - Terraform and default-jre
      
Creating a script to install the dependencies would be an efficient solution as the script is resuable and can be included in the terraform main.tf file.
With both infrastructures deployed, is there anything else we should add to our infrastructure? We should include a monitoring service like Data Dog within our infrastructure. Maintaining multiple servers can get overwhelming. If we use a monitoring service we can setup alerts that will let us know when our attention is needed to a particular server.

 
