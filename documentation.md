# Purpose
In our prior deployments, we traditionally hosted our applications in a single region. In this deployment, we used a more distributed approach using the Jenkins Server/Agent Architecture. This has allowed us to easily deploy our application across multiple regions. 

To accomplish this, we've leveraged Terraform for infrastructure provisioning, embracing Infrastructure as Code (IaC) principles. The result is an increase in our application's resilience. Now, we maintain two versions of our application concurrently in each region.

This strategic move not only enhances the resilience of our application but also significantly reduces latency. Our valued customers in the western region, for instance, can access the application from a data center closer to them. This localized access greatly enhances the overall user experience, ensuring faster response times and smoother interactions.
    
# Issues
* When I created the instances using Terraform, I used an incorrect AMI that installed Linux. I used the command "terraform destroy" to delete the configured resources. This allowed me to put the correct AMI ID in the tfvars file and create the instances with Ubuntu.
* When running the Jenkins build, the test stage failed with the error:
  "E   MySQLdb.OperationalError: (2003, "Can't connect to MySQL server on 'mydatabase.cczam3a4yemt.us-east-1.rds.amazonaws.com:3306' (110)") ".
The port "3306" was not opened. Once I edited the inbound rules in security. The test stage passed successfully.
# Steps
### Step 1
* Use Terraform to create two instances to create a Jenkins server and agent architecture.
  - Install on the Jenkins Server
      - Instance 1:
        - Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-              dev, python3.7-dev
  - Install on the Jenkins Agent
    - Instance 2:
        - Terraform and default-jre
### Step 2 
Create two VPCs with Terraform, 1 VPC in US-east-1 and the other VPC in US-west-2. MUST have the following components in each VPC:
* 2 AZ's
* 2 Public Subnets
* 2 EC2's
* 1 Route Table
* Security Group Ports: 8000 and 22

### Step 3
Create a user data script that will install the dependencies below and deploy the Banking application:
* software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
    - Once you activate the virtual environment, the following must be installed: pip install mysqlclient, pip install gunicorn
### Step 4
Create an RDS database. If you are unsure how to do this, use these instructions [https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw]
* Be sure to add port 3306 to your inbound port rules under security
### Step 5
Edit your database url to reflect the information for your RDS.
### Step 6
Add your credentials to be used as environment variables
### Step 7
Run a Jenkins Multi-branch build
  
# System Diagram

# Optimization (How would make this deployment more efficient)
* I manually installed the following dependencies:
  Instance 1:
    - Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev,         python3.7-dev
  Instance 2:
    - Terraform and default-jre
      
Creating a script to install the dependencies would be an efficient solution as the script is resuable and can be included in the terraform main.tf file.
### With both infrastructures deployed, is there anything else we should add to our infrastructure? 
* We should include a monitoring service like Data Dog within our infrastructure. Maintaining multiple servers can get overwhelming. If we use a monitoring service we can setup alerts that will let us know when our attention is needed to a particular server.

 
