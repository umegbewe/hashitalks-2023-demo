# hashitalks-2023-demo

### From Chaos to Consistency: Building Reliable Environments with Packer and Terraform

## Contents

**app/main.go**: This is a simple Go web application that interacts with a SQLite database and exposes three endpoints: /entries, /create, and /clear.

**images/packer.sh**: This script sets up the environment for the Go application in an Amazon Linux 2 instance, builds the application, creates a systemd service for it, and starts the service.

**images/template.json**: This is the Packer template that uses the amazon-ebs builder to create an AMI. It uploads the application code to the instance, then uses the packer.sh script to provision the instance.

**main.tf**: This is the Terraform script that deploys an EC2 instance using the AMI created by Packer. It also creates a security group that allows inbound traffic on ports 80, 8080, and 22.

## Prerequisites

* You need to have [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) and [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed on your machine.
* You need to have AWS CLI installed and configured with your AWS credentials.


## How to run
* Build the AMI using Packer
Run the following command:
```
  cd images
  packer build template.json
```
After the command finishes, you will see the ID of the new AMI in the output.
* Deploy the EC2 instance using Terraform
First, initialize Terraform with the following command:
```
  terraform init
```
Then, apply the Terraform plan with the following command:
```
  terraform apply
```
This command will prompt you to enter the ID of the subnet in which to deploy the instance, the ID of the VPC, and the name of the key pair to use for the instance but could also be populated in ``variables.tf``

After the terraform apply command finishes, we have the EC2 instance running with the application.

## Accessing the Application

To access the application, open a web browser and navigate to the public DNS or the public IP of the EC2 instance.

You can use the following endpoints:
* **/entries**: List all entries in the database [GET]
* **/create**: Create a new entry (use a POST request with a form parameter named name)
* **/clear**: Clear all entries from the database (use a DELETE request)

## Cleaning Up
To destroy the resources created by Terraform, run the following command:
```
  terraform destroy
```
