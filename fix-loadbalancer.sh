#!/bin/bash

# Script to fix the load balancer configuration issue
echo "=== Fixing Load Balancer Configuration ==="

# Navigate to infra directory
cd infra

# First, we need to manually remove the target group references in AWS
echo "Step 1: Removing old target group references..."

# Import the current state and force remove the target group
terraform state list | grep target_group_attachment | while read resource; do
    echo "Removing state for: $resource"
    terraform state rm "$resource"
done

# Remove the old target group from state
terraform state list | grep "lb_target_group.dev_proj_1_lb_target_group" | while read resource; do
    echo "Removing state for: $resource"  
    terraform state rm "$resource"
done

echo "Step 2: Planning new infrastructure..."
terraform plan

echo "Step 3: Applying new infrastructure..."
terraform apply -auto-approve

echo "Load balancer fix completed!"