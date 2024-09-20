Refer https://github.com/ajnaikka/ecs_pipeline for deployment files

Deploying Odoo ERP on AWS with a Serverless Architecture:

Objective: Deploy a comprehensive ERP solution using serverless architecture, ensuring scalability, availability, and security.

•	Compute: Utilized ECS Fargate for application containers, enabling seamless scaling and abstracting infrastructure management.
•	Database: Implemented Amazon Aurora PostgreSQL for its high performance, scalability, and redundancy.
•	Networking: Hosted the deployment within a private VPC with separate subnet groups for public and private resources.
•	Storage: Leveraged EFS for multi-AZ file storage, ensuring data consistency and resilience.
•	Security: Used AWS Secrets Manager for secure credential storage and a bastion host for controlled access.
•	Container Registry: Managed Docker images with Amazon ECR for secure and efficient deployments.
•	Logging and Monitoring: Utilized CloudTrail for auditing and compliance, storing logs in S3.
•	Encryption: Ensured in-flight encryption using AWS ACM at the ALB level.
•	Load Balancing and DNS: Configured ALB and Amazon Route 53 for traffic management and reliability.
•	Service Leveraged: VPC, ECS, ECR, R53, ACM, ALB, ASG, EFS, S3, EC2 (bastion server), RDS (Aurora), CloudTrail, DynamoDB (Terraform state).

