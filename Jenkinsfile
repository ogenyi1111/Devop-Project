pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-app'
        IMAGE_TAG = "build-${env.BUILD_NUMBER}"
        CONTAINER_NAME = 'flask_app_latest'
        SLACK_COLOR_SUCCESS = '#00FF00'
        SLACK_COLOR_FAIL = '#FF0000'
        SLACK_COLOR_DEFAULT = '#439FE0'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    slackSend(color: SLACK_COLOR_DEFAULT, message: "📦 *Checkout* started.")
                }
                git branch: 'main', url: 'https://github.com/ogenyi1111/test_flask'
                script {
                    slackSend(color: SLACK_COLOR_SUCCESS, message: "✅ *Checkout* completed.")
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    slackSend(color: SLACK_COLOR_DEFAULT, message: "🏗️ *Build* started.")
                    if (isUnix()) {
                        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    } else {
                        bat "docker build -t %IMAGE_NAME%:%IMAGE_TAG% ."
                    }
                    slackSend(color: SLACK_COLOR_SUCCESS, message: "✅ *Build* completed.")
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    slackSend(color: SLACK_COLOR_DEFAULT, message: "🧪 *Test* started.")
                    if (isUnix()) {
                        sh "docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} echo 'Container test successful'"
                    } else {
                        bat "docker run --rm %IMAGE_NAME%:%IMAGE_TAG% echo Container test successful"
                    }
                    slackSend(color: SLACK_COLOR_SUCCESS, message: "✅ *Test* completed.")
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    slackSend(color: SLACK_COLOR_DEFAULT, message: "🚀 *Deploy* started.")
                    if (isUnix()) {
                        sh """
                            docker stop ${CONTAINER_NAME} || true
                            docker rm ${CONTAINER_NAME} || true
                            docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    } else {
                        bat """
                            docker stop %CONTAINER_NAME% || exit 0
                            docker rm %CONTAINER_NAME% || exit 0
                            docker run -d -p 5000:5000 --name %CONTAINER_NAME% %IMAGE_NAME%:%IMAGE_TAG%
                        """
                    }
                    slackSend(color: SLACK_COLOR_SUCCESS, message: "✅ *Deploy* completed.")
                }
            }
        }
    }

    post {
        always {
            slackSend(color: '#FFFF00', message: "🟡 Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished. Check: ${env.BUILD_URL}")
        }
        success {
            slackSend(color: SLACK_COLOR_SUCCESS, message: "✅ Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded!")
        }
        failure {
            slackSend(color: SLACK_COLOR_FAIL, message: "❌ Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed!")
        }
    }
}