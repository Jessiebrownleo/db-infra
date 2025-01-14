#!/bin/bash

# Fixed base directory
BASE_DIR="/home/sen/cloudinator"
cd "${BASE_DIR}"

# Input variables
DB_NAME=$1                  # Database name (required)
DB_TYPE=$2                  # Database type (required)
DB_VERSION=$3              # Database version (required)
NAMESPACE=$4               # Namespace (required)
DB_PASSWORD=$5             # Database password (required for MySQL)
DB_USERNAME=${6:-defaultUser} # Database username (default for MySQL)
DOMAIN_NAME=$7             # Optional domain name for Ingress
STORAGE_SIZE=${8:-1Gi}     # Default storage size
PORT=${9:-30000}           # Default port for NodePort

# Validate required parameters
if [ -z "$DB_NAME" ] || [ -z "$DB_TYPE" ] || [ -z "$DB_VERSION" ] || [ -z "$NAMESPACE" ]; then
    echo "❌ Error: Missing required parameters"
    echo "Usage: $0 DB_NAME DB_TYPE DB_VERSION NAMESPACE [DB_PASSWORD] [DB_USERNAME] [DOMAIN_NAME] [STORAGE_SIZE] [PORT]"
    echo "Example: $0 mydb mysql 8.0 my-namespace mysecretpass dbuser"
    exit 1
fi

# Source all utility scripts using absolute paths
source "${BASE_DIR}/scripts/database/utils.sh"
source "${BASE_DIR}/scripts/database/validate.sh"
source "${BASE_DIR}/scripts/database/configure.sh"
source "${BASE_DIR}/scripts/database/namespace.sh"
source "${BASE_DIR}/scripts/database/storage.sh"
source "${BASE_DIR}/scripts/database/network.sh"
source "${BASE_DIR}/scripts/database/service.sh"
source "${BASE_DIR}/scripts/database/statefulset.sh"
source "${BASE_DIR}/scripts/database/ingress.sh"

# Export variables for use in templates
export DB_NAME DB_TYPE DB_VERSION NAMESPACE DB_PASSWORD DB_USERNAME DOMAIN_NAME STORAGE_SIZE PORT
export BASE_DIR

# Main deployment function
main() {
    echo "🚀 Starting database deployment..."
    
    create_namespace_resources
    validate_unique_deployment
    
    NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
    echo "Debug - Selected Node: ${NODE_NAME}"
    export NODE_NAME
    
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