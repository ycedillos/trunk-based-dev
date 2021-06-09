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