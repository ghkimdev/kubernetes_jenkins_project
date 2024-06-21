node {
    stage('Git Checkout') {
        git branch: 'main', url: 'https://github.com/ghkimdev/kubernetes_jenkins_project.git'
    }

    stage('Sending docker file to Ansible server using sshagent') {
        sshagent(['ansible_server']) {
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01'
            sh 'scp /opt/jenkins/workspace/pipeline-demo/Dockerfile vagrant@master01:/home/vagrant'
        }
    }
    stage ('Build the Docker Image') {
        sshagent(['ansible_server']) {
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 cd /home/vagrant'
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 sudo docker image build -t $JOB_NAME:v1.$BUILD_ID -f /home/vagrant/Dockerfile .'
        }
    }
    stage ('Docker Image Tagging') {
        sshagent(['ansible_server']) {
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 cd /home/vagrant'
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 sudo docker image tag $JOB_NAME:v1.$BUILD_ID ghkimdev/$JOB_NAME:v1.$BUILD_ID'
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 sudo docker image tag $JOB_NAME:v1.$BUILD_ID ghkimdev/$JOB_NAME:latest'
        }
    }
    stage ('Push Docker Image to Docker Hub') {
        sshagent(['ansible_server']) {
            withCredentials([string(credentialsId: 'dockerhub_access1', variable: 'dockerhub_access')]) {
            sh "ssh -o StrictHostKeyChecking=no vagrant@master01 sudo docker login -u ghkimdev -p $dockerhub_access"
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 sudo docker image push ghkimdev/$JOB_NAME:v1.$BUILD_ID'
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 sudo docker image push ghkimdev/$JOB_NAME:latest'
            }
        }
    }
    stage ('Copy the files jenkins server to kubernetes server') {
          sshagent(['kubernetes_login']) {
          sh 'ssh -o StrictHostKeyChecking=no vagrant@master01'
          sh 'scp /opt/jenkins/workspace/pipeline-demo/Deployment.yaml vagrant@master01:/home/vagrant'
          sh 'scp /opt/jenkins/workspace/pipeline-demo/Service.yaml vagrant@master01:/home/vagrant'
        }
    }
    stage ('Sending Ansible playbook to Ansible Server over ssh') {
        sshagent(['ansible_server']) {
            sh 'ssh -o StrictHostKeyChecking=no vagrant@master01'
            sh 'scp /opt/jenkins/workspace/pipeline-demo/ansible.yaml vagrant@master01:/home/vagrant'
        } 
    }
    stage ('Kubernetes deployment using Ansible') {
        sshagent(['ansible_server']) {
		sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 cd /home/vagrant'
		sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 kubectl delete -f /home/vagrant/Deployment.yaml'
		sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 kubectl delete -f /home/vagrant/Service.yaml'
		sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 kubectl apply -f /home/vagrant/Deployment.yaml'
		sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 kubectl apply -f /home/vagrant/Service.yaml'
//		sh 'ssh -o StrictHostKeyChecking=no vagrant@master01 ansible-playbook ansible.yaml'
        }
    }        
}

