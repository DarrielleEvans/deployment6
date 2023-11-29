<h1 align="center">BankApp Deployment: Terraform, Jenkins, & Amazon RDS<h1> 

# Purpose 
In the previous deployment, I deployed multiple versions of the banking application, with each version hosted in distinct subnets to minimize downtime risks. However, a significant drawback of this approach was that each application version operated with its own separate database. This architectural choice presented challenges, especially when considering the user experience across different availability zones. Customers accessing the application from various locations could encounter unsynchronized sessions, leading to inconsistencies and a poor user experience.

To address these issues, I have now deployed the application across two different regions, aiming to significantly reduce latency and enhance overall accessibility. More importantly, I have integrated a unified Amazon Relational Database Service (RDS) that connects with the application in each region. This modification ensures data synchronization across all sessions, regardless of the user's location. By implementing this change, we achieve data redundancy and maintain a consistent, seamless user experience.

# Deployment Steps 
## Step 1
- Plan the deployment
  - Diagram the deployment using a professional diagramming tool such as Draw.io.
  - Create a GitHub repository and upload source code and related files.
  - Identify the technology being utilized.
    
## Step 2
- Use Terraform to create a Jenkins manager/agent setup with two instances. The Jenkins agent has terraform installed. Instead of deploying the applications on a Jenkins agent, I am automating the deployment using Terraform and including a user-data-script that contains the commands to deploy the application. Using Terraform scripts to automate the deployment speeds up the deployment process by reducing manual effort, reduces human error and promotes consistency as the templates can be reused when scaling our system, and can also save money in the long run being that resources can be quickly terminated.  
  - Jenkins Manager: Install the following dependencies
    - Jenkins: 
    - software-properties-common
    - add-apt-repository -y ppa:deadsnakes/ppa
    - python3.7
    - python3.7-venv
    - build-essential
    - libmysqlclient-dev
    - python3.7-dev

  - Jenkins Agent: Install the following dependencies
    - Terraform
    - Default-Jre
## Step 3
- Create an infrastructure across two AWS( East and West) regions using Terraform
- Resources to Deploy in each region
  - 2 AZ's
  - 2 Public Subnets
  - 2 EC2's
  - Install the following dependencies using a user data script on each instance  
  - 1 Route Table
  - Security Group Ports: 8000 and 22  


# Technologies used
# Troubleshooting
# Application Deployed
# System Diagram
# Optimization 
