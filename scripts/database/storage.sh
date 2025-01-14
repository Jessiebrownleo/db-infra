#!/bin/bash

create_storage_class() {
    if ! kubectl get storageclass local-storage &>/dev/null; then
        kubectl apply -f "/home/sen/cloudinator/templates/storageclass.yaml"
    fi
}

create_persistent_volume() {
    envsubst < "/home/sen/cloudinator/templates/pv.yaml" | kubectl apply -f -
}

create_persistent_volume_claim() {
    envsubst < "/home/sen/cloudinator/templates/pvc.yaml" | kubectl apply -f -
}

wait_for_pvc() {
    log "⏳ Waiting for PVC to bind..."
    kubectl wait --for=condition=Bound pvc/${DB_NAME}-pvc -n ${NAMESPACE} --timeout=60s
}

initialize_host_directory() {
    log "📂 Initializing host directory..."
    sudo mkdir -p /data/${NAMESPACE}/${DB_NAME}
    sudo chown -R 999:999 /data/${NAMESPACE}/${DB_NAME}
    sudo chmod -R 700 /data/${NAMESPACE}/${DB_NAME}
}