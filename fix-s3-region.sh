#!/bin/bash

# Script to fix S3 bucket region mismatch
# Deletes the bucket in wrong region and creates it in the correct region

BUCKET_NAME="dev-proj-1-remote-state-bucket-1234567891011"
CORRECT_REGION="eu-central-1"

echo "🔧 Fixing S3 bucket region mismatch..."
echo "Bucket: $BUCKET_NAME"
echo "Target region: $CORRECT_REGION"

# Check if bucket exists
aws s3api head-bucket --bucket $BUCKET_NAME 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Bucket exists. Checking current region..."
    
    # Get current bucket region
    CURRENT_REGION=$(aws s3api get-bucket-location --bucket $BUCKET_NAME --query 'LocationConstraint' --output text 2>/dev/null)
    
    # Handle 'None' response (which means us-east-1)
    if [ "$CURRENT_REGION" == "None" ]; then
        CURRENT_REGION="us-east-1"
    fi
    
    echo "Current region: $CURRENT_REGION"
    
    if [ "$CURRENT_REGION" != "$CORRECT_REGION" ]; then
        echo "❌ Bucket is in wrong region: $CURRENT_REGION"
        echo "🗑️ Deleting bucket from wrong region..."
        
        # Empty the bucket first (in case there are objects)
        aws s3 rm s3://$BUCKET_NAME --recursive
        
        # Delete the bucket
        aws s3api delete-bucket --bucket $BUCKET_NAME --region $CURRENT_REGION
        
        if [ $? -eq 0 ]; then
            echo "✅ Bucket deleted successfully"
        else
            echo "❌ Failed to delete bucket. Please delete manually:"
            echo "   aws s3 rb s3://$BUCKET_NAME --force"
            exit 1
        fi
        
        echo "⏳ Waiting 10 seconds for DNS propagation..."
        sleep 10
    else
        echo "✅ Bucket is already in correct region: $CORRECT_REGION"
        exit 0
    fi
else
    echo "ℹ️ Bucket doesn't exist. Will create it."
fi

echo "🏗️ Creating bucket in correct region: $CORRECT_REGION"

# Create the S3 bucket in the correct region
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $CORRECT_REGION \
    --create-bucket-configuration LocationConstraint=$CORRECT_REGION

if [ $? -eq 0 ]; then
    echo "✅ Bucket created successfully!"
    
    # Enable versioning
    aws s3api put-bucket-versioning \
        --bucket $BUCKET_NAME \
        --versioning-configuration Status=Enabled
    
    # Enable encryption
    aws s3api put-bucket-encryption \
        --bucket $BUCKET_NAME \
        --server-side-encryption-configuration '{
            "Rules": [
                {
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }
            ]
        }'
    
    # Block public access
    aws s3api put-public-access-block \
        --bucket $BUCKET_NAME \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    
    echo "✅ Bucket configured with security best practices"
    echo "🚀 You can now run 'terraform init' successfully!"
else
    echo "❌ Failed to create bucket"
    exit 1
fi