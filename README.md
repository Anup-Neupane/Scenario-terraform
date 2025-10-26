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

# Terraform AWS Infrastructure - Modular Approach

A modular Terraform configuration for deploying AWS infrastructure including S3 buckets, Lambda functions, IAM roles, and DynamoDB with state locking.

## 📁 Project Structure

```
fixed-module/
├── backend-resources/         # Initial backend setup (S3 + DynamoDB)
│   └── main.tf
├── modules/                   # Reusable Terraform modules
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── lambda_function/           # Lambda function source code
│   └── index.py
├── backend.tf                # Terraform backend configuration
├── main.tf                   # Root module configuration
├── variables.tf              # Variable definitions
├── outputs.tf                # Output definitions
├── terraform.tfvars.example  # Example variables file
└── create_function_zip.sh    # Lambda ZIP creation script
```

## 🚀 Quick Start

### Prerequisites

- **AWS Account** with appropriate permissions
- **Terraform** 1.0 or later installed
- **AWS CLI** configured with credentials
- **Zip** utility installed

### Step 1: Clone and Setup

```bash
git clone <your-repository>
cd fixed-module
```

### Step 2: Configure Variables

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

**Example `terraform.tfvars`:**
```hcl
aws_region   = "us-east-2"
project_name = "fuse-demo"
environment  = "dev"
bucket_suffix = "67"
```

### Step 3: Create Backend Resources (First Time Only)

The backend resources (S3 bucket for state storage and DynamoDB for locking) need to be created first with local state.

```bash
cd backend-resources

# Initialize with local state
terraform init

# Plan and create backend resources
terraform plan -out=tfplan
terraform apply tfplan

# Note the outputs - you'll need these
cd ..
```

### Step 4: Prepare Lambda Function

```bash
# Create the Lambda function ZIP package
chmod +x create_function_zip.sh
./create_function_zip.sh
```

This creates `function.zip` in the root directory.

### Step 5: Initialize Main Configuration

```bash
# Initialize with S3 backend
terraform init

# You'll be prompted to migrate state to S3 - type "yes"
```

### Step 6: Deploy Infrastructure

```bash
# Review the execution plan
terraform plan -out=tfplan

# Apply the configuration
terraform apply tfplan

# Or apply directly
terraform apply
```

## 🏗 Architecture

This Terraform configuration deploys:

### Core Components:
- **S3 Bucket**: For file storage with versioning enabled
- **Lambda Function**: Python function triggered by S3 uploads
- **IAM Roles & Policies**: Least privilege access for Lambda
- **DynamoDB Table**: For Terraform state locking (backend)
- **S3 Backend**: Secure state storage with encryption

### Resource Relationships:
1. S3 bucket stores uploaded files
2. Lambda function processes new S3 objects
3. IAM role grants Lambda access to S3 and CloudWatch
4. S3 notification triggers Lambda on file upload
5. DynamoDB provides state locking for Terraform

## 📋 Manual Deployment Steps

### Complete Step-by-Step Process:

```bash
# 1. Navigate to project
cd fixed-module

# 2. Configure AWS credentials (if not already done)
aws configure

# 3. Setup backend resources first
cd backend-resources
terraform init
terraform apply
cd ..

# 4. Create Lambda ZIP
chmod +x create_function_zip.sh
./create_function_zip.sh

# 5. Initialize main configuration
terraform init

# 6. Validate configuration
terraform validate
terraform fmt -check

# 7. Plan deployment
terraform plan -var-file=terraform.tfvars -out=plan.out

# 8. Apply configuration
terraform apply plan.out

# 9. Verify deployment
terraform output
```

## 🔧 Module Details

### S3 Module (`modules/s3/`)
Creates S3 buckets with:
- Versioning enabled
- Server-side encryption
- Public access blocking
- Proper tagging

### IAM Module (`modules/iam/`)
Creates IAM resources with:
- Lambda execution role
- S3 read permissions
- CloudWatch logging
- Least privilege principles

### Lambda Module (`modules/lambda/`)
Deploys Lambda function with:
- S3 trigger configuration
- Environment variables
- Proper dependencies
- ZIP package deployment

## ⚙️ Configuration

### Variables (`variables.tf`)

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for resources | `us-east-2` |
| `project_name` | Project name for resource naming | `fuse-demo` |
| `environment` | Environment (dev/staging/prod) | `dev` |
| `bucket_suffix` | Unique suffix for bucket names | `67` |

### Outputs

After deployment, you'll get:
- S3 bucket names
- Lambda function ARN and name
- IAM role ARN

## 🔄 Operations

### Updating Infrastructure

```bash
# Make changes to Terraform files
terraform plan -out=plan.out
terraform apply plan.out
```

### Destroying Resources

```bash
# Destroy all resources (use with caution)
terraform destroy

# Destroy with specific targets
terraform destroy -target=module.lambda
```

### Checking State

```bash
# Show current state
terraform show

# List resources
terraform state list

# Get specific resource details
terraform state show aws_s3_bucket.my_bucket
```

## 🛠 Troubleshooting

### Common Issues

1. **Backend Initialization Error**
   ```bash
   # Ensure backend resources exist
   cd backend-resources && terraform apply
   ```

2. **Lambda ZIP Not Found**
   ```bash
   # Recreate the ZIP file
   ./create_function_zip.sh
   ```

3. **State Lock Issues**
   ```bash
   # Force unlock if stuck (use carefully)
   terraform force-unlock LOCK_ID
   ```

4. **Permission Errors**
   ```bash
   # Verify AWS credentials
   aws sts get-caller-identity
   ```

### Debug Commands

```bash
# Check Terraform version
terraform version

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Refresh state
terraform refresh
```

## 🔒 Security Notes

- **State File**: Stored encrypted in S3 with versioning
- **State Locking**: DynamoDB prevents concurrent modifications
- **IAM Policies**: Follow principle of least privilege
- **S3 Buckets**: Block all public access by default
- **Credentials**: Never commit AWS credentials to repository

## 📝 Lambda Function

The deployed Lambda function (`lambda_function/index.py`):

```python
import json
import boto3
import os

def handler(event, context):
    """
    Processes S3 file uploads
    Triggered when files are uploaded to S3 bucket
    """
    print(f"Received event: {json.dumps(event)}")
    
    for record in event.get('Records', []):
        if record['eventSource'] == 'aws:s3':
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            
            print(f"Processing file: s3://{bucket}/{key}")
            
            # Add your file processing logic here
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': f'Successfully processed {key}',
                    'bucket': bucket,
                    'key': key
                })
            }
    
    return {
        'statusCode': 400,
        'body': json.dumps({'message': 'No S3 records found'})
    }
```

## 🧹 Cleanup

To completely remove all resources:

```bash
# Destroy main infrastructure
terraform destroy

# Destroy backend resources (after main infrastructure)
cd backend-resources
terraform destroy

# Remove local files
rm -f function.zip
rm -f *.tfplan
rm -f .terraform.lock.hcl
rm -rf .terraform/
```


---

**Note**: Always test in a development environment before deploying to production. Monitor AWS costs and set up billing alerts.
