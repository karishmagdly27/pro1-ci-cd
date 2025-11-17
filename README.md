🚀 CI/CD Pipeline Setup – Full Documentation

This guide documents the complete workflow to provision infrastructure, configure servers, and deploy an application using:

Terraform (Infrastructure provisioning)

Ansible (Server configuration)

Jenkins (CI/CD pipeline)

SonarQube (Code quality)

Nexus (Artifact Repository)

✅ 1. Provision Infrastructure (Terraform)

Navigate to your Terraform directory:

terraform init
terraform apply


This creates:

3 EC2 servers (Dev, Staging, Prod)

Jenkins server

SonarQube server

Nexus server

Security groups, key pairs, and networking

✅ 2. Configure App Servers (Ansible)

Move into Ansible directory:

cd /mnt/d/Karishma/NCPL/Bootcamp/pro1-ci-cd/ansible

2.1 Setup Dev Server
ssh -i ~/.ssh/ci_cd_key.pem ubuntu@3.134.102.126
ansible-playbook -i inventory.ini playbooks/app_env.yml -l app_dev

2.2 Setup Staging Server
ssh -i ~/.ssh/ci_cd_key.pem ubuntu@3.134.88.210
ansible-playbook -i inventory.ini playbooks/app_env.yml -l app_staging

2.3 Setup Production Server
ssh -i ~/.ssh/ci_cd_key.pem ubuntu@18.191.129.250
ansible-playbook -i inventory.ini playbooks/app_env.yml -l app_prod

✅ 3. Configure Jenkins Server

Login to Jenkins server:

ssh -i ~/.ssh/ci_cd_key.pem ubuntu@3.21.127.191
ansible-playbook -i inventory.ini playbooks/jenkins.yml

Jenkins URL:
http://3.21.127.191:8080

Retrieve initial password:
cat /var/lib/jenkins/secrets/initialAdminPassword


Credentials:

User: admin
Password: 8340ccf651d7460da4d9815d635ad424

✅ 4. Configure SonarQube Server
ssh -i ~/.ssh/ci_cd_key.pem ubuntu@3.21.127.191
ansible-playbook -i inventory.ini playbooks/sonarqube.yml

SonarQube URL:
http://3.21.127.191:9000


Credentials:

User: admin
Password: Kari$8488

✅ 5. Configure Nexus Repository Manager
ssh -i ~/.ssh/ci_cd_key.pem ubuntu@3.18.108.166
ansible-playbook -i inventory.ini playbooks/nexus.yml

Nexus URL:
http://3.18.108.166:8081

Retrieve admin password:
cat /opt/nexus/sonatype-work/nexus3/admin.password


Credentials:

User: admin
Password: Kari$8488

✅ 6. Add Required Credentials to Jenkins

Go to:

Jenkins → Manage Jenkins → Credentials

Add these:

Name	Type	Description
github-token	Personal Access Token	For Git repo checkout
nexus-creds	Username/Password	To upload artifacts to Nexus
dev-app-server	SSH Key	For deployment to EC2
sonar-token	Secret Text	For SonarQube Analysis

✅ 7. Create Jenkins Multibranch Pipeline

Go to New Item → Multibranch Pipeline

Add GitHub repo URL

Add GitHub credentials

Jenkins will scan branches and detect Jenkinsfile

Ensure Jenkinsfile exists in dev, stg, master branches

✅ 8. Prepare / Update Jenkinsfile

Push a Jenkinsfile into each branch:

dev → Deploy to Dev server

stg → Upload artifact + deploy to Staging

master → Upload artifact + manual approval + deploy to Prod

✅ 9. Push Code to Respective Branch
git checkout dev
git add .
git commit -m "ci/cd pipeline update"
git push origin dev


Repeat for:

stg

master

🎉 Pipeline Flow

dev branch

SonarQube scan

Build ZIP

Deploy directly to Dev EC2

stg branch

SonarQube scan

Build ZIP

Upload ZIP to Nexus

Deploy to Staging EC2

master branch

SonarQube scan

Build ZIP

Upload artifact to Nexus

Manual approval

Deploy to Production