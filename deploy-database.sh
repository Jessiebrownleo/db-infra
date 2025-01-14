#!/bin/bash

# Source all utility scripts
source scripts/database/utils.sh
source scripts/database/validate.sh
source scripts/database/configure.sh
source scripts/database/namespace.sh
source scripts/database/storage.sh
source scripts/database/network.sh
source scripts/database/service.sh
source scripts/database/statefulset.sh
source scripts/database/ingress.sh

# Main deployment function
main() {
    echo "🚀 Starting database deployment..."
    
    create_namespace_resources
    validate_unique_deployment
    
    NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
    echo "Debug - Selected Node: ${NODE_NAME}"
    
    configure_database
    create_storage_class
    create_network_policy
    initialize_host_directory
    create_persistent_volume
    create_persistent_volume_claim
    
    echo "⏳ Waiting for PVC to bind..."
    kubectl wait --for=condition=Bound pvc/${DB_NAME}-pvc -n ${NAMESPACE} --timeout=60s
    
    create_statefulset
    create_service
    
    if [ ! -z "${DOMAIN_NAME}" ]; then
        create_ingress
    fi
    
    print_deployment_summary
}

# Execute main function
main