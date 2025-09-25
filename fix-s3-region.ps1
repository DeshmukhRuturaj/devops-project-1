# PowerShell script to fix S3 bucket region mismatch
# Deletes the bucket in wrong region and creates it in the correct region

$BucketName = "dev-proj-1-remote-state-bucket-1234567891011"
$CorrectRegion = "eu-central-1"

Write-Host "🔧 Fixing S3 bucket region mismatch..." -ForegroundColor Yellow
Write-Host "Bucket: $BucketName" -ForegroundColor Cyan
Write-Host "Target region: $CorrectRegion" -ForegroundColor Cyan

# Check if bucket exists and get its region
Write-Host "Checking if bucket exists..." -ForegroundColor Yellow

$bucketLocation = aws s3api get-bucket-location --bucket $BucketName --query 'LocationConstraint' --output text 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Bucket exists. Current region: $bucketLocation" -ForegroundColor Green
    
    # Handle 'None' response (which means us-east-1) or null
    if ($bucketLocation -eq "None" -or [string]::IsNullOrEmpty($bucketLocation)) {
        $bucketLocation = "us-east-1"
        Write-Host "✅ Bucket exists in us-east-1 region" -ForegroundColor Green
    }
    
    if ($bucketLocation -ne $CorrectRegion) {
        Write-Host "❌ Bucket is in wrong region: $bucketLocation" -ForegroundColor Red
        Write-Host "🗑️ Deleting bucket from wrong region..." -ForegroundColor Yellow
        
        # Empty the bucket first
        aws s3 rm s3://$BucketName --recursive
        
        # Delete the bucket
        aws s3api delete-bucket --bucket $BucketName
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Bucket deleted successfully" -ForegroundColor Green
            Write-Host "⏳ Waiting 10 seconds for DNS propagation..." -ForegroundColor Yellow
            Start-Sleep -Seconds 10
        } else {
            Write-Host "❌ Failed to delete bucket" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "✅ Bucket is already in correct region!" -ForegroundColor Green
        exit 0
    }
} else {
    Write-Host "ℹ️ Bucket doesn't exist. Will create it." -ForegroundColor Blue
}

# Create the bucket
Write-Host "🏗️ Creating bucket in region: $CorrectRegion" -ForegroundColor Yellow
aws s3api create-bucket --bucket $BucketName --region $CorrectRegion --create-bucket-configuration LocationConstraint=$CorrectRegion

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Bucket created successfully!" -ForegroundColor Green
    
    # Enable versioning
    Write-Host "📝 Enabling versioning..." -ForegroundColor Yellow
    aws s3api put-bucket-versioning --bucket $BucketName --versioning-configuration Status=Enabled
    
    # Enable encryption
    Write-Host "🔐 Enabling encryption..." -ForegroundColor Yellow
    aws s3api put-bucket-encryption --bucket $BucketName --server-side-encryption-configuration '{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}'
    
    # Block public access
    Write-Host "🛡️ Configuring security..." -ForegroundColor Yellow
    aws s3api put-public-access-block --bucket $BucketName --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    
    Write-Host "✅ Bucket configured with security best practices" -ForegroundColor Green
    Write-Host "🚀 You can now run your Jenkins job again!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create bucket" -ForegroundColor Red
    exit 1
}