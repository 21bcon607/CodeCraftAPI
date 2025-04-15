pipeline {
  agent any

  environment {
    ACR_NAME = 'codecraftacr11561223'
    IMAGE_NAME = 'codecraft-api'
    RESOURCE_GROUP = 'codecraft-rg'
    CLUSTER_NAME = 'codecraft-aks'
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/21bcon607/CodeCraftAPI.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('app') {
          script {
            sh "az acr login --name $ACR_NAME"
            sh "docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:latest ."
            sh "docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:latest"
          }
        }
      }
    }

    stage('Deploy to AKS') {
      steps {
        script {
          sh "az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing"
          sh "kubectl apply -f k8s/deployment.yaml"
          sh "kubectl apply -f k8s/service.yaml"
        }
      }
    }
  }
}
