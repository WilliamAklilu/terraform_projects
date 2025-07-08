
# 🛠️ Terraform AWS 3-Tier Architecture (Web, App & RDS Database)

This project provisions a **3-tier architecture** on AWS using Terraform. It launches **web and application EC2 instances** across public and private subnets, respectively, and connects them to a backend **RDS database**. The web tier serves an NGINX web server, the app tier runs a Flask application that interacts with the database, and the DB tier hosts a MySQL-compatible RDS instance.

---

## 📁 Project Structure

```
.
├── ec2.tf         # EC2 instance definitions for Web & App tiers
├── locals.tf      # Local values (e.g., Roman numeral naming)
└── variables.tf   # (Expected) Variable definitions (not provided)
```

---

## 🌐 Architecture Overview

- **Web Tier (Public Subnet)**
  - EC2 instances running Ubuntu
  - NGINX web server with a custom HTML message
  - Public IP association for internet access
  - Named: `Web-srv-I`, `Web-srv-II`, etc.

- **App Tier (Private Subnet)**
  - EC2 instances running Ubuntu
  - Python Flask app that:
    - Connects to an RDS database
    - Exposes a `/health` and `/write` endpoint
  - Background service using `nohup`
  - Named: `App-srv-I`, `App-srv-II`, etc.

- **Database Tier (Private Subnet)**
  - Amazon RDS (MySQL-compatible)
  - Receives connection from app tier
  - Stores messages written by the app

- **AMI Source**: Latest Ubuntu 20.04 LTS from Canonical  
- **Security Group**: Shared or tier-specific, assumed `aws_security_group.app_sg`
- **Key Pair**: Uses an existing key

---

## 🧱 Components

### 🔹 locals.tf

```hcl
locals {
  roman = ["I", "II"]
}
```
Defines Roman numeral suffixes for naming EC2 instances (e.g., `Web-srv-I`, `App-srv-II`).

---

### 🔹 ec2.tf

#### Web Tier

```hcl
resource "aws_instance" "web" {
  count         = length(aws_subnet.public)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[count.index].id
  associate_public_ip_address = true
  key_name      = "terraform_ec2"
  ...
}
```

- Installs NGINX via `user_data`
- Displays a simple welcome page using the instance name
- Tags for identification

#### App Tier

```hcl
resource "aws_instance" "app" {
  count         = length(aws_subnet.private)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private[count.index].id
  key_name      = "terraform_ec2"
  ...
}
```

- Installs Flask and PyMySQL via `user_data`
- Connects to an RDS DB instance (assumed `aws_db_instance.rds`)
- Starts Flask app in background
- Writes and reads messages from the DB

---

## 📥 Input Variables (Expected)

> **Note:** `variables.tf` is missing, but the code references the following variables:

- `var.instance_type`: EC2 instance type (e.g., `t3.micro`)
- `var.db_username`, `var.db_password`, `var.db_name`: Credentials for the RDS DB

---

## 🏷️ Tags

All EC2 instances are tagged for easy identification:
- Web Tier: `Name = Web-srv-I`, `Web-srv-II`
- App Tier: `Name = App-srv-I`, `App-srv-II`

---

## 🚀 Usage

1. Clone the repository.
2. Ensure you have `terraform`, a valid AWS profile, and `terraform_ec2` key pair set up.
3. Customize `variables.tf` to include the required variables.
4. Initialize and apply:

```bash
terraform init
terraform apply
```

---

## 📌 Requirements

- AWS CLI & credentials
- Terraform ≥ 1.0
- Pre-created:
  - VPC, subnets (`aws_subnet.public`, `aws_subnet.private`)
  - RDS instance (`aws_db_instance.rds`)
  - Key pair (`terraform_ec2`)
  - Security group (`aws_security_group.app_sg`)

---

## ✅ Example Output

- Web server at: `http://<public-ip>`
- App health check: `http://<private-ip>:5000/health`
- Write endpoint: `curl -X POST -d "message=Hello" http://<private-ip>:5000/write`
