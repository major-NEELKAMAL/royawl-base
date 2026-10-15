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
              sh "docker container prune -f"
              sh "docker image prune -f"
              sh "docker builder prune -f"
            }
          }
        }

        stage('Docker Image Create') {
          steps {
            script {
              // Builds the new arm64 base image (native on the Graviton Jenkins; the test VM is arm64 too) and loads it into the local Docker daemon
              // --pull fetches the latest eclipse-temurin:21-jdk instead of a cached copy
              sh "docker buildx build --pull --platform linux/arm64 -t ${IMAGE_NAME} --load ."
            }
          }
        }

        stage('Verify Base Image') {
          steps {
            script {
              // Fails the build if any tool required by downstream services is missing
              sh """
                docker run --rm --platform linux/arm64 --entrypoint sh ${IMAGE_NAME} -c '
                  set -e
                  java -version
                  mysqldump --version
                  ffmpeg -version | head -n 1
                  ls /usr/lib/jni/libopencv_java*.so
                '
              """
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
