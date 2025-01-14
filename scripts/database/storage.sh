#!/bin/bash

create_storage_class() {
    if ! kubectl get storageclass local-storage &>/dev/null; then
        envsubst < templates/storageclass.yaml | kubectl apply -f -
    fi
}

initialize_host_directory() {
    echo "Creating storage directory..."
    sudo mkdir -p /data/${NAMESPACE}/${DB_NAME}
    sudo chown -R 999:999 /data/${NAMESPACE}/${DB_NAME}
    sudo chmod -R 700 /data/${NAMESPACE}/${DB_NAME}
}

create_persistent_volume() {
    envsubst < templates/pv.yaml | kubectl apply -f -
}

create_persistent_volume_claim() {
    envsubst < templates/pvc.yaml | kubectl apply -f -
}