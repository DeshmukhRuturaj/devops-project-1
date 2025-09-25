pipeline {
    agent any

    parameters {
            booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
            booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
            booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
            booleanParam(name: 'FIX_LOADBALANCER', defaultValue: false, description: 'Check to fix load balancer configuration issues')
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clean workspace before cloning (optional)
                deleteDir()

                // Clone the Git repository using checkout scm for better branch handling
                checkout scm
                
                // Alternative explicit git clone if needed
                // git branch: 'main',
                //     url: 'https://github.com/DeshmukhRuturaj/devops-project-1.git'

                sh "ls -lart"
            }
        }

        stage('Terraform Init') {
                    steps {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-ruturaj']]){
                            dir('infra') {
                            sh 'echo "=================Terraform Init=================="'
                            sh 'terraform init'
                        }
                    }
                }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    if (params.PLAN_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-ruturaj']]){
                            dir('infra') {
                                sh 'echo "=================Terraform Plan=================="'
                                sh 'terraform plan'
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    if (params.APPLY_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-ruturaj']]){
                            dir('infra') {
                                sh 'echo "=================Terraform Apply=================="'
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    if (params.DESTROY_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-ruturaj']]){
                            dir('infra') {
                                sh 'echo "=================Terraform Destroy=================="'
                                sh 'terraform destroy -auto-approve'
                            }
                        }
                    }
                }
            }
        }

        stage('Fix LoadBalancer') {
            steps {
                script {
                    if (params.FIX_LOADBALANCER) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-ruturaj']]){
                            dir('infra') {
                                sh 'echo "=================Fixing LoadBalancer Config=================="'
                                sh 'echo "Step 1: Removing all target group references from state..."'
                                sh 'terraform state list | grep target_group_attachment | xargs -r terraform state rm || true'
                                sh 'terraform state list | grep "lb_target_group.aws_lb_target_group" | head -1 | xargs -r terraform state rm || true'
                                sh 'echo "Step 2: Force refresh state..."'
                                sh 'terraform refresh'
                                sh 'echo "Step 3: Planning with cleaned state..."'
                                sh 'terraform plan'
                                sh 'echo "Step 4: Applying fixed configuration..."'
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                }
            }
        }
    }
}