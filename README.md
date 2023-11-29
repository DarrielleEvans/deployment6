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
    - Terraform: An Infrastructure as Code tool used for building, changing, and versioning infrastructure safely and efficiently across        various cloud providers
    - Default-Jre: This is essential for running Java applications, providing the necessary runtime libraries and components.
    
## Step 4
- I've established an AWS RDS Database that seamlessly connects with our applications deployed across both Eastern and Western regions. The implementation of this relational database enhances our users' experience by guaranteeing data consisteny and integrity. It provides a centralized data management system, ensuring a single, consistent version of data across all platforms.
  - A key step in this process involved opening port 3306 enabling uninterrupted traffic flow to and from the database.
  <img width="257" alt="Screen Shot 2023-11-29 at 5 18 46 PM" src="https://github.com/DarrielleEvans/deployment6/assets/89504317/6e24debd-a560-4a8c-8f9b-0e1608e4011a">

  
## Step 3
- Create a main.tf file to spin up an infrastructure across two AWS( East and West) regions and automate the application deployments using Terraform.
- Resources to Deploy in each region
  - 2 AZ's
  - 2 Public Subnets
  - 2 EC2's
  - Install the following dependencies using a user data script on each instance  
  - 1 Route Table
  - Security Group Ports: 8000 and 22  
## Build and Test the application using Jenkins 
- Created a Jenkins file to run the following stages:
  1. Build Stage:
    Purpose: Set up the project environment and install dependencies.
    What Happens:
    A Python virtual environment is created using Python 3.7.
    This environment is activated.
    Pip (Python package manager) is upgraded.
    Project-specific dependencies listed in requirements.txt are installed.
  2. Test Stage:
     Purpose: Run tests to ensure the application works as expected.
     What Happens:
     The same Python virtual environment is activated.
     Additional dependencies for testing (like mysqlclient and pytest) are installed.
     Tests are run using pytest, and results are saved in an XML file.
     Post-Actions:
     Regardless of the test outcome, the test results are published (using the junit command) for review.
  3. Init Stage:
     Purpose: Initialize Terraform for infrastructure management.
     What Happens:
     The pipeline switches to a specific agent labeled 'awsDeploy'.
     AWS credentials are securely fetched.
     In the initTerraform directory, Terraform is initialized to prepare for infrastructure management.
  4. Plan Stage:
     Purpose: Create an execution plan for Terraform.
     What Happens:
     Still on the 'awsDeploy' agent.
     AWS credentials are used again.
     Terraform generates an execution plan (plan.tfplan) in the initTerraform directory, showing what it will do when the plan is applied.
  5. Apply Stage:
     Purpose: Apply the Terraform plan to make infrastructure changes.
     What Happens:
     Continuing on the 'awsDeploy' agent.
     After retrieving AWS credentials, the Terraform plan created in the previous stage is applied, executing the changes to the               infrastructure as defined in the plan.
     <img width="1056" alt="Screen Shot 2023-11-29 at 5 05 14 PM" src="https://github.com/DarrielleEvans/deployment6/assets/89504317/36320d96-b8c0-468b-84cf-69edb97a3704">

# Troubleshooting
During the Jenkins build process, I encountered an error highlighting the absence of an agent with the 'awsDeploy' label. This error was a clear indicator that the Jenkins pipeline requires specific configurations to run successfully. To resolve this, I set up a new agent node and assigned it the 'awsDeploy' label. Following this adjustment, the pipeline executed smoothly and without any further issues.
![agentError](https://github.com/DarrielleEvans/deployment6/blob/main/screenshots/agentError.jpeg)


# Application Deployed
# System Diagram
![Diagram](https://github.com/DarrielleEvans/deployment6/blob/main/screenshots/d6.drawio.png)

# Optimization 
### Fault Tolerant
While provisioning RDS with our banking application effectively ensures data consistency and integrity, it alone does not provide fault tolerance in our system. Relying on a single database instance poses a risk; in the event of a failure, access to customer banking information could be compromised. To mitigate this, I can implement a backup database. Thanks to RDS's scalability features, I can easily set up and manage this secondary database. This approach guarantees that we always have a reliable, up-to-date backup, ensuring uninterrupted service to our customers even during unforeseen disruptions.

### Monitoring Service
I should include a monitoring service like Data Dog within our infrastructure. Maintaining multiple servers can get overwhelming. If I use a monitoring service I can setup alerts that will let me know when my attention is needed to a particular server.
