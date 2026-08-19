pipeline {
  agent any

  triggers {
    githubPush()
  }

  environment {
    IMAGE_NAME = "com.aryanlab.royawl/royawl-base:latest"
  }

  stages {
    stage('Production Guard') {
      when {
        anyOf {
          branch 'main'
          expression { env.GIT_BRANCH == 'origin/main' }
          triggeredBy 'UserIdCause'
        }
      }
      stages {
        stage('Prepare') {
          steps {
            checkout scm
          }
        }

        stage('Docker Image Create') {
          steps {
            script {
              sh "docker build --platform linux/amd64 -t ${IMAGE_NAME} ."
            }
          }
        }
          
        
      }
    }
  }

  post {
    failure { echo "Image creation failed!" }
    success { echo "Image creation successful." }
  }
}

