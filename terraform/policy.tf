resource "aws_iam_policy" "terraform_policy" {
  name        = "TerraformPolicy"
  description = "Policy for Terraform to manage EC2, VPC, NLB, DynamoDB, and S3"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:*",
          "vpc:*",
          "elasticloadbalancing:*",
          "dynamodb:*",
          "s3:*"
        ],
        "Resource": "*"
      }
    ]
  })
}
