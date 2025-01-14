#!/bin/bash

# Log file
LOG_FILE="/home/sen/cloudinator/deploy-database.log"

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Input variables
DB_NAME=$1
DB_TYPE=$2
DB_VERSION=$3
NAMESPACE=${4:-default}
DB_PASSWORD=$5
DB_USERNAME=${6:-defaultUser}
DOMAIN_NAME=$7
STORAGE_SIZE=${8:-1Gi}
PORT=${9:-30000}

# Source all scripts
SCRIPT_DIR="/home/sen/cloudinator/scripts"
source "${SCRIPT_DIR}/database/validate.sh"
source "${SCRIPT_DIR}/database/configure.sh"
source "${SCRIPT_DIR}/database/storage.sh"
source "${SCRIPT_DIR}/database/network.sh"
source "${SCRIPT_DIR}/database/namespace.sh"
source "${SCRIPT_DIR}/database/statefulset.sh"
source "${SCRIPT_DIR}/database/service.sh"
source "${SCRIPT_DIR}/database/utils.sh"

# Main deployment function
main() {
    log "🚀 Starting database deployment..."
    
    
    
    # Configure database
    configure_database
    echo "Configure database"
    
    # Create StorageClass
    create_storage_class
    echo "Validate storage class"
    # Create NetworkPolicy
    create_network_policy
    echo "Create network policy"
    # Initialize host directory
    initialize_host_directory
    echo "Initialize host directory"
    # Create namespace and secret
    create_namespace_resources
    echo "Create namespace resources"
    # Create PV
    create_persistent_volume
    echo "Create persistent volume"
    # Create PVC
    create_persistent_volume_claim
    echo "Create persistent volume claim"
    # Wait for PVC to bind
    wait_for_pvc
    echo "Wait for PVC to bind"
    # Create StatefulSet
    create_statefulset
    echo "Create stateful set"
    # Create Service
    create_service
    echo "Create service"
    # Create Ingress (if domain name is provided)
    if [ ! -z "${DOMAIN_NAME}" ]; then
        create_ingress
    fi
    
    log "✅ Database deployment completed successfully!"
    print_deployment_details
}

# Execute main function
main