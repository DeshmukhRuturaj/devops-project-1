#!/bin/bash
set -e

echo "=== Load Balancer Dependency Fix Script ==="

# Navigate to infra directory
cd /var/lib/jenkins/workspace/jenkins-terraform\ project/infra

echo "Step 1: Removing target group attachments from Terraform state..."
terraform state list | grep "aws_lb_target_group_attachment" | while read resource; do
    echo "Removing state for: $resource"
    terraform state rm "$resource" || true
done

echo "Step 2: Removing old target group from state..."
terraform state list | grep "module.lb_target_group.aws_lb_target_group.dev_proj_1_lb_target_group" | while read resource; do
    echo "Removing state for: $resource"
    terraform state rm "$resource" || true
done

echo "Step 3: Import existing target group with new name..."
# This allows the new target group to be created without conflicts
terraform import 'module.lb_target_group.aws_lb_target_group.dev_proj_1_lb_target_group' arn:aws:elasticloadbalancing:eu-central-1:484907517932:targetgroup/dev-proj-1-lb-target-group/4301a43b4c1cc0c2 || true

echo "Step 4: Applying changes..."
terraform apply -auto-approve

echo "Load balancer configuration fix completed!"