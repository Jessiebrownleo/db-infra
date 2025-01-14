#!/bin/bash

kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace ${NAMESPACE} name=${NAMESPACE} --overwrite