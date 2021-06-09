#!/bin/bash

source ci-cd/scripts/functions.sh

#Set variables based on the environment
set_environment

# Download and install heml
install_helm

# Login into GKE
gcp_login

# Get all the secrets
set_secrets

if [ "`kubectl get po -n ${CERT_MANAGER_NAMESPACE} --ignore-not-found | grep Running`" ]; then
  echo 'The NGINX is already deployed!!';
else
  # Configure NGINX ingress controller
  get_reserved_ip
  install_NGINX_ingress_controller

  # Configure Cert Manager Controller
  install_custom_resource_definition
  install_cert_manager_controller
fi 

# for testing
kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0 -n ${CHART_NAMESPACE}

kubectl expose deployment hello-app --port=8080 --target-port=8080 -n ${CHART_NAMESPACE}

kubectl create -f ci-cd/k8s/sample/ingress-resource.yaml -n ${CHART_NAMESPACE}