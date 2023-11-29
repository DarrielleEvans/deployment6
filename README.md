<h1 align="center">BankApp Deployment: Terraform, Jenkins, & Amazon RDS<h1> 

# Purpose 
In the previous deployment, I deployed multiple versions of the banking application, with each version hosted in distinct subnets to minimize downtime risks. However, a significant drawback of this approach was that each application version operated with its own separate database. This architectural choice presented challenges, especially when considering the user experience across different availability zones. Customers accessing the application from various locations could encounter unsynchronized sessions, leading to inconsistencies and a poor user experience. 

To address these issues, in this deployment I deployed the application across two different regions, aiming to significantly reduce latency and enhance overall accessibility. More importantly, I have integrated a unified Amazon Relational Database Service (RDS) that connects with the application in each region. This modification ensures data synchronization across all sessions, regardless of the user's location. I also improved the deployment process by using Jenkins and Terraform to automate the deployment process. The benefits of this improvement is that Terraform reduces the amount of manual effort using SSh requires such as managing keys and keeping track of resources. Using Terraform and Jenkins is good for error handling, state management, reusability and collaboration. By implementing this change, we achieve data redundancy and maintain a consistent, seamless user experience.

# Deployment Steps 
## Step 1
- Plan the deployment
  - Diagram the deployment using a professional diagramming tool such as Draw.io.
  - Create a GitHub repository and upload source code and related files.
  - Identify the technology being utilized.
    
## Step 2
- Use Terraform to create a Jenkins manager/agent setup with two instances. The Jenkins agent has terraform installed. Instead of deploying the applications on a Jenkins agent, I am automating the deployment using Terraform and including a user-data-script that contains the commands to deploy the application. Using Terraform scripts to automate the deployment speeds up the deployment process by reducing manual effort, reduces human error and promotes consistency as the templates can be reused when scaling our system, and can also save money in the long run being that resources can be quickly terminated.  
  - Jenkins Manager: Install the following dependencies
     - software-properties-common: This package provides necessary tools to manage the software repositories that your system uses,              making it easier to install and update software.
     - add-apt-repository -y ppa:deadsnakes/ppa: This command adds the Deadsnakes PPA to your system, which is a repository containing           newer releases of Python not provided by the default Ubuntu repositories.
     - python3.7: Installs Python 3.7, a specific version of Python, ensuring compatibility and consistency for your Python-based                applications or scripts.
     - python3.7-venv: This package provides the Python 3.7 virtual environment tool, allowing you to create isolated Python environments        for different projects or dependencies.
     - build-essential: A meta-package that installs the GNU compiler collection and related tools, essential for compiling and building         software from source code.
     - libmysqlclient-dev: This library is necessary for building Python modules that interact with MySQL databases, enabling database           connectivity and operations.
     - python3.7-dev: Includes development tools and header files for Python 3.7, needed for building Python extensions or compiling             Python packages that include native code

  - Jenkins Agent: Install the following dependencies
    - Terraform
    - Default-Jre
    
## Step 4
- I've established an AWS RDS Database that seamlessly connects with our applications deployed across both Eastern and Western regions. The implementation of this relational database enhances our users' experience by guaranteeing data consisteny and integrity. It provides a centralized data management system, ensuring a single, consistent version of data across all platforms.
  - A key step in this process involved opening port 3306 enabling uninterrupted traffic flow to and from the database. 
  
## Step 3
- Create a main.tf file to spin up an infrastructure across two AWS( East and West) regions and automate the application deployments using Terraform.
- Resources to Deploy in each region
  - 2 AZ's
  - 2 Public Subnets
  - 2 EC2's
  - Install the following dependencies using a user data script on each instance  
  - 1 Route Table
  - Security Group Ports: 8000 and 22  
## Build and Test the application using Jenkins build
- Created a Jenkins file to run the following stages:


# Troubleshooting
# Application Deployed
# System Diagram
# Optimization 
