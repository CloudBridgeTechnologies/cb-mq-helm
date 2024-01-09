#! /bin/bash
# © Copyright IBM Corporation 2023
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -x

export TARGET_NAMESPACE=${1:-"default"}
if [ $# -gt 3 ]
  then
    MQ_ADMIN_PASSWORD_NAME="--set queueManager.envVariables[0].name=MQ_ADMIN_PASSWORD"
    MQ_ADMIN_PASSWORD_VALUE="--set queueManager.envVariables[0].value=${3}"
    MQ_APP_PASSWORD_NAME="--set queueManager.envVariables[1].name=MQ_APP_PASSWORD"
    MQ_APP_PASSWORD_VALUE="--set queueManager.envVariables[1].value=${4}"
    APPLICATION_NAME="${2}"
    persistence_datapvc_size="--set persistence.dataPVC.size=${9}"
    persistence_logpvc_size="--set persistence.logPVC.size=${10}"
    persistence_qmpvc_size="--set persistence.qmPVC.size=${11}"
    resources_cpu_limit="--set resources.limits.cpu=${12}"
    resources_memory_limit="--set resources.limits.memory=${13}"
    resources_cpu_request="--set resources.requests.cpu=${14}"
    resources_memory_request="--set resources.limits.memory=${15}"
fi

echo "...Queue Manager Application Name is $APPLICATION_NAME..."
echo "...Namespace is $TARGET_NAMESPACE..."

if [ $# -eq 15 ]
  then
    LB_ANNOTATION="--set-string route.loadBalancer.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-internal=${5}"
    LB_ANNOTATION="--set-string route.loadBalancer.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-subnets=${6}\,${7}\,${8}"
fi

export QM_KEY=$(cat ../../genericresources/createcerts/server.key | base64 | tr -d '\n')
export QM_CERT=$(cat ../../genericresources/createcerts/server.crt | base64 | tr -d '\n')
export APP_CERT=$(cat ../../genericresources/createcerts/application.crt | base64 | tr -d '\n')

( echo "cat <<EOF" ; cat mtlsqm.yaml_template ; echo EOF ) | sh > mtlsqm.yaml

kubectl config set-context --current --namespace=$TARGET_NAMESPACE
kubectl apply -f mtlsqm.yaml

helm install $APPLICATION_NAME ../../../charts/ibm-mq -f secureapp_nativeha.yaml $MQ_ADMIN_PASSWORD_NAME $MQ_ADMIN_PASSWORD_VALUE $MQ_APP_PASSWORD_NAME $MQ_APP_PASSWORD_VALUE $LB_ANNOTATION $persistence_datapvc_size $persistence_logpvc_size $persistence__qmpvc_size $resources_cpu_request $resources_memory_request  
