#!/bin/bash

# Create StorageClass
kubectl apply -f ./templates/storageclass.yaml

# Create PersistentVolume
envsubst < ./templates/pv.yaml | kubectl apply -f -

# Create PersistentVolumeClaim
envsubst < ./templates/pvc.yaml | kubectl apply -f -

# Wait for PVC to bind
kubectl wait --for=condition=Bound pvc/${DB_NAME}-pvc -n ${NAMESPACE} --timeout=120s