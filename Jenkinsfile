pipeline{
  agent any
  tools {
    maven 'Maven 3.6.2'
    jdk 'jdk8'
  }
  stages {
    stage('Initialize') {
      steps {
        sh '''
          echo "PATH = ${PATH}"
          echo "M2_HOME = ${M2_HOME}"
        '''
      }
    }
    stage('Build') {
      steps {
        sh 'mvn install'
      }
    }
    stage('Make Container') {
      steps {
        sh """
          docker build -t willwbowen/salonapi-gateway:${env.BUILD_ID} .
          docker tag willwbowen/salonapi-gateway:${env.BUILD_ID} willwbowen/salonapi-gateway:latest
        """
      }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh """
            docker login -u ${USERNAME} -p ${PASSWORD}
            docker push willwbowen/salonapi-gateway:${env.BUILD_ID}
            docker push willwbowen/salonapi-gateway:latest
          """
        }
      }
    }
    stage('Deploy') {
      steps {
        sh """
          kubectl apply -f ./k8s/deployment.yml
          kubectl apply -f ./k8s/service.yml
        """
      }
    }
  }
  post {
    always {
      archiveArtifacts 'target/**/*.jar'
    }

  }
}
