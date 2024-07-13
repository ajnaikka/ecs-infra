pipeline {
  agent any

  //AWS creds
  environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
  
  stages {
    stage('Checkout') {
      steps {
             script {
                    def gitInfo = checkout scm
                    env.repo_name = gitInfo.GIT_URL.split('/')[-1].replace('.git', '')
                }
      }
    }

    // stage('Infra Destroy') {
    //   steps {
    //     dir('manifests') {
    //       sh 'terraform init'
    //       sh 'terraform destroy -auto-approve'
    //     }
    //   }
    // }

    stage('Infra Build') {
      steps {
        dir('manifests') {
          sh 'terraform init'
          sh 'terraform validate'
          sh 'terraform plan'
          sh 'terraform apply -auto-approve'
        }
      }
    }

    // stage('Read Sensitive Data'){
    //     steps {
    //         dir('manifests') {
    //         sh 'terraform output -json > terraform_output.json'
    //         }
    //     }
    // }

  }
}
