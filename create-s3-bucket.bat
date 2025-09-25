@echo off
REM Script to create S3 bucket for Terraform remote state
REM This should be run once before running Terraform

set BUCKET_NAME=dev-proj-1-remote-state-bucket-1234567891011
set REGION=eu-central-1

echo Creating S3 bucket: %BUCKET_NAME% in region: %REGION%

REM Create the S3 bucket
aws s3api create-bucket --bucket %BUCKET_NAME% --region %REGION% --create-bucket-configuration LocationConstraint=%REGION%

REM Enable versioning on the bucket (recommended for Terraform state)
aws s3api put-bucket-versioning --bucket %BUCKET_NAME% --versioning-configuration Status=Enabled

REM Enable server-side encryption (recommended for security)
aws s3api put-bucket-encryption --bucket %BUCKET_NAME% --server-side-encryption-configuration "{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}"

REM Block public access (security best practice)
aws s3api put-public-access-block --bucket %BUCKET_NAME% --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo S3 bucket %BUCKET_NAME% created successfully!
echo You can now run 'terraform init' to initialize the remote backend.