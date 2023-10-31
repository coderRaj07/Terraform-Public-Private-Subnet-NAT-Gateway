```markdown
# AWS VPC Setup with Public and Private Subnets

This Terraform configuration sets up an Amazon Web Services (AWS) Virtual Private Cloud (VPC) with both public and private subnets. It also includes the creation of EC2 instances in these subnets.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS CLI installed and configured with your AWS credentials.

## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:

   ```bash
   cd <project-directory>
   ```

3. Create a `terraform.tfvars` file in the project directory and provide your own values for variables like `aws_region`, `key_name`, and any other necessary variables. Here's an example:

   ```hcl
   aws_region = "us-east-1"
   key_name = "your-ec2-key-pair-name"
   ```

4. Initialize the Terraform working directory:

   ```bash
   terraform init
   ```

5. Review and apply the Terraform plan:

   ```bash
   terraform apply
   ```

6. After the infrastructure is created, Terraform will output the public and private EC2 instance IDs. You can use these to SSH into your instances.

7. When you're done using the infrastructure, you can destroy it:

   ```bash
   terraform destroy
   ```

## Configuration

- The Terraform configuration creates a VPC with a public and a private subnet.
- It associates the public subnet with a Route Table that routes traffic through an Internet Gateway.
- It associates the private subnet with a Route Table that routes traffic through a NAT Gateway.
- Two EC2 instances are launched, one in the public subnet and another in the private subnet.
- Security group rules are configured to allow incoming SSH (port 22) traffic and allow all outgoing traffic.

## Customization

You can customize the following variables in the `terraform.tfvars` file or directly in the Terraform configuration files:

- `aws_region`: Set your desired AWS region.
- `key_name`: Provide the name of your EC2 key pair.
- Instance type, AMI, and other instance settings in the EC2 resource blocks.
- Security group rules in the `aws_security_group` resource.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

Replace `<repository-url>` and `<project-directory>` with your repository URL and project directory name. Additionally, customize the `terraform.tfvars` example with your AWS region and key pair name.

This README template includes sections for prerequisites, usage, configuration, customization, and licensing. You can use it as a starting point for your own README.md file.
