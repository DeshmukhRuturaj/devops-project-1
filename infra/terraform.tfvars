bucket_name = "dev-proj-1-remote-state-bucket-1234567891012"
name        = "environment"
environment = "dev-1"

vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev-proj-eu-central-vpc-1"
cidr_public_subnet   = ["10.0.1.0/24", "10.0.2.0/24"]
cidr_private_subnet  = ["10.0.3.0/24", "10.0.4.0/24"]
eu_availability_zone = ["eu-central-1a", "eu-central-1b"]

public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPXQZd/7uyT0FRUmMrldFZUYJThSIIENbuBrO/2jTAp7SO8wSuiKy4IJLK4/DBi1B+ox7Q+UQSXICtmCJTIMayzSeutR6a2qlztDYSbBsK7atrlvt1Z0J/+KEybmMudY4dO1qx775ZXKHTRBjb+92MuCEJWCgAQRBlbtE8Vo6KNH905FXSOh/LQFyD3F2MNJtir+VGlZmReOx57/aZmlxrbF1/eUCsH04xDIES85oq9gfIhAK8ZYNmnzdxvKL3ipy5LWSJBvg4DveIIylELOBMHribonzYnEJRSJ0hg98uITLQlfFNmGXEF4X+dFOLH3wAuTGf+cgFvGexKTfWDZxNR+oQJXV+rgb+rYqtnhG/vS1Xp+nGCQF/ELL6yDJKPiXbPJkgHPW7UzYtS9UWUmxGr4ulGJ1peq8gHNEtMujI/rYsAjpM8/GejukbUxoBdbNWxQzYT6qm7FNuN75gu+jy5GMyFA52MkJFlzauFA1vTZtOm7+Y30IL0iLrqs+W/x8J8WD9w8lORo6Bvq9iOzljVrVoVagqOGPuirm6pzpfIauXsJYDHo8BT1UWxaTYus5pRZTeEoWCkshQ1XsbJQrtPIETcYMjiil8NKRCUq60d/IYaeRpX2aJFnS2rvjKhaUhN+xE7m5D77aAF0lI0yGi/U9N1p2v6jZ4cbxq4IGBZQ== rutur@RD"
ec2_ami_id     = "ami-0084a47cc718c111a"

ec2_user_data_install_apache = ""

domain_name = "deshmukhruturaj.tech"