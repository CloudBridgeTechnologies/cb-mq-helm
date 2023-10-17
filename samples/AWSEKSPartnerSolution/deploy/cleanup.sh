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

export TARGET_NAMESPACE=default
APPLICATION_NAME=devqm

helm delete $APPLICATION_NAME
kubectl delete secret helmsecure -n $TARGET_NAMESPACE
kubectl delete configmap helmsecure -n $TARGET_NAMESPACE
kubectl delete pvc data-$APPLICATION_NAME-ibm-mq-0 -n $TARGET_NAMESPACE
kubectl delete pvc data-$APPLICATION_NAME-ibm-mq-1 -n $TARGET_NAMESPACE
kubectl delete pvc data-$APPLICATION_NAME-ibm-mq-2 -n $TARGET_NAMESPACE
kubectl delete pvc log-$APPLICATION_NAME-ibm-mq-0 -n $TARGET_NAMESPACE
kubectl delete pvc log-$APPLICATION_NAME-ibm-mq-1 -n $TARGET_NAMESPACE
kubectl delete pvc log-$APPLICATION_NAME-ibm-mq-2 -n $TARGET_NAMESPACE
kubectl delete pvc qm-$APPLICATION_NAME-ibm-mq-0 -n $TARGET_NAMESPACE
kubectl delete pvc qm-$APPLICATION_NAME-ibm-mq-1 -n $TARGET_NAMESPACE
kubectl delete pvc qm-$APPLICATION_NAME-ibm-mq-2 -n $TARGET_NAMESPACE
