# 🚀 Terraform Lambda S3 Python Project

This project demonstrates how to use **Terraform** to build an **event-driven AWS architecture** where an **AWS Lambda function** automatically processes files uploaded to an **S3 bucket**.

It includes two directories:
- **`broken/`** – Example with dependency issues.  
- **`fixed/`** – Correct, production-ready version with proper dependency handling and state management.

---

🧭 Step-by-Step Commands

1️⃣ Initialize Terraform
cd broken
terraform init


Initializes the Terraform working directory and downloads required providers.

2️⃣ Validate Configuration
terraform validate


Validates that the Terraform files are properly written and formatted.

3️⃣ Create an Execution Plan
terraform plan


Previews the actions Terraform will take.
In this broken example, the plan might still succeed — but applying may cause errors due to missing dependency links.

4️⃣ Apply the Configuration
terraform apply

Applies the plan and attempts to create resources.
Type yes when prompted.

🧩 Next Step

To see the correct version, move to the fixed/ directory:

cd ../fixed

Then follow the same commands (terraform init, validate, plan, apply) to deploy a working, production-ready setup.
