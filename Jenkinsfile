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

        stage('Delete Existing Base Image') {
          steps {
            script {
              // Removes the old base image layer if present to ensure a fresh build context
              sh "docker rmi -f ${IMAGE_NAME} || true"
            }
          }
        }

        stage('Docker Image Create') {
          steps {
            script {
              // Builds the new amd64 base image and loads it into the local Docker daemon
              sh "docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} --load ."
            }
          }
        }

        stage('Cleanup Dangling Layers') {
          steps {
            script {
              // Removes leftover intermediate build artifacts without affecting active/tagged images
              sh "docker image prune -f"
            }
          }
        }
      }
    }
  }

  post {
    failure { echo "Base image creation failed!" }
    success { echo "Base image updated successfully." }
  }
}
