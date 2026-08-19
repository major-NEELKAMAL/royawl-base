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
              // Using buildx guarantees correct architecture build from arm64 host to amd64
              sh "docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} --load ."
            }
          }
        }
      }
    }
  }

  post {
    failure { echo "Base image creation failed!" }
    success { echo "Base image creation successful." }
  }
}
