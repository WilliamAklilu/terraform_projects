# terraform_projects
# ☁️ AWS Terraform Infrastructure Project (Free Tier Optimized)

This project builds a secure, modular cloud environment using Terraform and AWS services—all while staying within AWS Free Tier limits. It's perfect for learning infrastructure-as-code, practicing security best practices, or creating a foundation for event-driven applications.

---

## 🔧 Architecture Overview

- **Virtual Private Cloud (VPC)**  
  Custom VPC with separate public and private subnets in one Availability Zone.

- **Internet Gateway & NAT Gateway**  
  Provides controlled internet access—public subnet connects directly, private subnet uses NAT.

- **EC2 Instance (Ubuntu)**  
  Deployed in the *private subnet*, accessible only via SSH using a key pair and outbound traffic via NAT Gateway.

- **S3 Bucket**  
  Secure storage with versioning, public access blocked, and optional encryption.

- **Lambda Function**  
  Lightweight function hosted in the public subnet for automation or event-driven use cases.

- **SSH Key Pair**  
  Used to authenticate secure access to the EC2 instance.

---

## 🎯 Project Goals

- Practice Terraform modularization with reusable `.tf` files.
- Demonstrate secure, production-style infrastructure patterns.
- Explore networking configurations using NAT, route tables, and subnet isolation.
- Automate compute resources and event-driven functionality with Lambda and S3.
- Stay within AWS Free Tier when possible (e.g. `t2.micro`, minimal usage of NAT Gateway).

---

## 📁 File Structure
aws-terraform-sample/ ├── main.tf           # Provider and Terraform settings ├── variables.tf      # Input variables ├── vpc.tf            # VPC, subnets, gateways, routing ├── ec2.tf            # Private EC2 instance and security group ├── lambda.tf         # Lambda function and IAM role ├── s3.tf             # S3 bucket setup ├── ssh.tf            # SSH key pair generation/import ├── outputs.tf        # Outputs like instance ID and S3 name

---

## 🔐 Security Highlights

- IAM policies follow the *least privilege* principle.
- All resources restricted to private access unless explicitly required.
- EC2 instance has no public IP and is protected with security groups and a key pair.
- Optional VPC Flow Logs and CloudTrail can be added for deeper audit visibility.

---

## ✅ Requirements

- Terraform v1.3 or later  
- AWS CLI configured with IAM user credentials  
- Access to an AWS account with Free Tier eligibility  
- Local machine: Windows 11 (as development environment)

---

## 🚀 Deploy Instructions

```bash
terraform init
terraform plan
terraform apply
