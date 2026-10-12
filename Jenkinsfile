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

        stage('Enable amd64 Emulation') {
          steps {
            script {
              // Jenkins runs on aarch64 (Graviton) while prod is x86_64; register QEMU so RUN steps
              // in the amd64 image can execute. Registration is lost on reboot, so do it every build.
              sh "docker run --privileged --rm tonistiigi/binfmt --install amd64"
            }
          }
        }

        stage('Docker Image Create') {
          steps {
            script {
              // Builds the new amd64 base image and loads it into the local Docker daemon
              // --pull fetches the latest eclipse-temurin:21-jdk instead of a cached copy
              sh "docker buildx build --pull --platform linux/amd64 -t ${IMAGE_NAME} --load ."
            }
          }
        }

        stage('Verify Base Image') {
          steps {
            script {
              // Fails the build if any tool required by downstream services is missing
              sh """
                docker run --rm --platform linux/amd64 --entrypoint sh ${IMAGE_NAME} -c '
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
