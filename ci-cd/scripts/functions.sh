# Array of service names
declare -a StringArray=("kh-media-svc" "kh-agent-svc" "kh-vendor-svc" "kh-profile-sv" "kh-api-gateway" "kh-vendor-web" )

install_helm () {
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
}

gcp_login () {
  curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
  export PATH=${HOME}/google-cloud-sdk/bin:${PATH}

  tar -xzf keys.tar.gz
 
  echo "TARGET_ENVIRONMENT: ${TARGET_ENVIRONMENT}"

  echo "ls -la ${TRAVIS_BUILD_DIR}"
  ls -la ${TRAVIS_BUILD_DIR}

  echo "ls -la ${TRAVIS_BUILD_DIR}/keys"
  ls -la ${TRAVIS_BUILD_DIR}/keys
  
  gcloud auth activate-service-account --key-file ${TRAVIS_BUILD_DIR}/keys/client-secret-${TARGET_ENVIRONMENT}.json

  gcloud --quiet config set project ${GCP_PROJECT}

  gcloud components install kubectl

  gcloud container clusters get-credentials ${GKE_CLUSTER} --region=${REGION}
}

set_environment () {  
  # TRAVIS_BRANCH
  #   for push builds, or builds not triggered by a pull request, this is the name of the branch.
  #   for builds triggered by a pull request this is the name of the branch targeted by the pull request.
  #   for builds triggered by a tag, this is the same as the name of the tag (TRAVIS_TAG)


  if [ "$TRAVIS_BRANCH" = "main" ] # for git push
  then 
    export TARGET_ENVIRONMENT=development

    echo 'Deployment to DEV'
  else
    echo 'testing'
  fi
}

set_secrets () {  
  
  echo "example"
}

get_reserved_ip () {
  export RESERVED_IP=$(gcloud compute addresses describe ${RESERVED_IP_NAME} --global --format="json" | jq .address | sed 's/"//g')
}

install_NGINX_ingress_controller () {
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update

  helm install kh-nginx-ingress ingress-nginx/ingress-nginx \ 
              -n ${CHART_NAMESPACE} \
              --set controller.service.loadBalancerIP=${RESERVED_IP} \
              --set rbac.create=true \
              --set controller.publishService.enabled=true
}

# Required to install Cert Manager Controller. It should be run only once time
install_custom_resource_definition () {
  kubectl create namespace ${CHART_NAMESPACE}
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.crds.yaml -n ${CHART_NAMESPACE}
}

# It should be run only once time
install_cert_manager_controller () {
  helm repo add jetstack https://charts.jetstack.io
  helm repo update

  helm install cert-manager jetstack/cert-manager \
              --namespace ${CERT_MANAGER_NAMESPACE} \
              --version ${CERT_MANAGER_VERSION}

  kubectl rollout status -n ${CERT_MANAGER_NAMESPACE} deploy/cert-manager  -w --timeout=7m

  kubectl apply -f ci-cd/k8s/resources/certificate-issuer.yaml

}

