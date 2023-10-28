# Purpose
    
# Issues
- When I created the instances using Terraform, I used an incorrect AMI that installed Linux. I used the command "terraform destroy" to delete the configured resources. This allowed me to put the correct AMI ID in the tfvar file and create the instances with Ubuntu.
# Steps
### Step 1
* Use Terraform to create two instances to create a Jenkins server and agent architecture.
  - Install on the Jenkins Server
  - Install on the Jenkins Agent
# System Diagram (Your diagram must include the default VPC, Regions East and West VPCs)
# Optimization (How would make this deployment more efficient)
