## Secure and Scalable Three-tier Web Application Deployment on AWS
This project demonstrates how to deploy a three-tier architecture on AWS using Terraform. A three tier architecture consisting of three layers: the web tier, the application tier, and the database tier. Each layer has a specific role and interacts with the other layers to form a scalable and resilient application, with components such as EC2 instances, RDS, Elastic Load Balancer (ELB), VPC, and ASG.
This project uses Terraform modules to organize and manage the infrastructure code effectively, making it easily reusable. 
- **Web Tier**: EC2 instances running in multiple Availability Zones, fronted by an Elastic Load Balancer.
- **Application Tier**: EC2 instances for application processing in a private subnets also load-balanced and running in multiple Availability Zones.
- **Database Tier**: An Amazon RDS instance running in a private subnets.

![Screenshot (342)](https://github.com/user-attachments/assets/1f694035-a7ac-4ac9-b372-4b92d2b8c5d4)

# Prerequisites
Before you begin, ensure you have:
- Basic knowledge of Terraform and AWS services such as EC2, ELB, ASG, RDS and VPC
- Terraform installed on your local machine
- An AWS account
- AWS CLI configured with appropriate IAM user credentials (secret access key and access key ID)

# Steps

# 1. Clone the repository
``` bash
git clone https://github.com/theglad-x/Three-Tier-Architecture-Deployment-on-AWS-with-Terraform.git
```

# 2. Change to the project folder
``` bash
cd Three-Tier-Architecture-Deployment-on-AWS-with-Terraform
```

# 3. Create S3 bucket to store the state file
Create S3 bucket for backend to store Terraform state file. The S3 bucket can be created in two ways
1. The configuration in `./s3-bucket.tf` file
2. Through the AWS management console

# 4. Configure email for ASG notification
Open in a text editor `main.tf` file in the project root directory and configure your email for web tier and app tier ASG notification

# 5. Configure Terraform Variables
In the project root directory, open `terraform.tfvars` in a text editor
Review and customize the values of the variables according to your reguirement.
- `image_name`: Set the value for ami filter
- `my_public_key`: Set location of the public key for keypair
- `db_password`: Set the database password
- `db_username`: Set username for the database
- `ip`: Set ip for the host machine

# 6. Formate configuration files
Run fmt command to fix any syntax error
```bash 
terraform fmt
```

# 7. Initialize Terraform
```bash
terraform init
```

# 8. Plan the deployment terraform plan
Run the following command to see all resources terraform will create and check if matches your expection
```bash 
terraform plan
```

# 9. Deploy the infrastructure
```bash 
terraform apply
```

# 10. Access the Application

After deployment is complete, the web application can be access via the Elastic Load Balancer's DNS name.
Copy the DNS name Terraform will output and paste it into your web browser.

# 11. Confirm Infrastructure
Login to AWS console to confirm all the resources created

![Screenshot (319)](https://github.com/user-attachments/assets/d07818de-fde2-4531-a7a9-e973c5b2534e)
![Screenshot (320)](https://github.com/user-attachments/assets/8a66db28-540e-4e41-b27d-7e5ba5d83423)
![Screenshot (321)](https://github.com/user-attachments/assets/044ba42c-e8b8-4215-9413-afce8748b807)
![Screenshot (322)](https://github.com/user-attachments/assets/0c1cace7-da82-4584-8859-4c0455d0184d)
![Screenshot (323)](https://github.com/user-attachments/assets/8fd371c6-11b2-41a8-b2ad-11626d1b5f7c)
![Screenshot (324)](https://github.com/user-attachments/assets/a6d914e1-ccda-4ae3-aebb-357d65457764)
![Screenshot (325)](https://github.com/user-attachments/assets/3557b32f-29da-4b67-a6e8-6f4881dd0fff)
![Screenshot (326)](https://github.com/user-attachments/assets/b1232f1e-f91b-403a-a8ca-2948b9e6cdb2)
![Screenshot (327)](https://github.com/user-attachments/assets/644a336a-f6ad-46e9-9f17-782683104078)
![Screenshot (328)](https://github.com/user-attachments/assets/ffcd2cbd-2fce-41eb-8ca6-2654e3cb6971)
![Screenshot (329)](https://github.com/user-attachments/assets/758e245a-3d84-43f0-ad24-b1f919234d09)
![Screenshot (330)](https://github.com/user-attachments/assets/6388c7c4-5755-4bd7-960c-71c96bb22f1c)
![Screenshot (332)](https://github.com/user-attachments/assets/b6d360ac-0303-442a-bd5e-07daecff493a)
![Screenshot (333)](https://github.com/user-attachments/assets/a7e65167-efcb-4964-abe3-ad01e67a901e)

# Terraform Modules
This project uses Terraform modules to organize and manage the infrastructure code effectively. You can reuse these modules or customize them as needed.

# Conclusion
This project demonstrates the power of Terraform in deploying a secure and scalable three-tier web application architecture on AWS. By leveraging Terraform modules and AWS services such as EC2, ELB, RDS, and ASG, this setup ensures high availability, fault tolerance, and ease of management. The modular nature of the code makes it reusable and adaptable to different requirements, allowing for customization and further expansion as needed.

With this setup, you can easily deploy, manage, and scale your infrastructure while maintaining best practices in cloud architecture. 
Ensure to follow Terraform's best practices for structuring configurations and AWS best practices. Secure sensitive data using Terraform's sensitive attribute and gitignore your .tfvars file
