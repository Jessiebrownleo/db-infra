#!/bin/bash
set -x  # Enable debug mode

# Logging
LOG_FILE="/home/sen/cloudinator/deploy-database.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "🚀 Starting database deployment at $(date)"

# Input variables
export DB_NAME=$1                  # Database name (required)
export DB_TYPE=$2                  # Database type (required)
export DB_VERSION=$3               # Database version (required)
export NAMESPACE=${4:-default}     # Default namespace
export DB_PASSWORD=$5              # Database password (required for MySQL)
export DB_USERNAME=${6:-defaultUser} # Database username (default for MySQL)
export DOMAIN_NAME=$7              # Optional domain name for Ingress
export STORAGE_SIZE=${8:-1Gi}      # Default storage size
export PORT=${9:-30000}            # Default port for NodePort (optional, default is 30000)
export NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')  # Get node name

# Error handling
handle_error() {
    local exit_code=$?
    local command="$BASH_COMMAND"
    echo "❌ Error: Command '$command' failed with exit code $exit_code."
    exit $exit_code
}
trap 'handle_error' ERR

# Source utility functions
source ./scripts/database/utils.sh

# Validate inputs
echo "🔍 Validating inputs..."
validate_inputs "${DB_NAME}" "${DB_TYPE}" "${DB_VERSION}"

# Configure database
echo "⚙️ Configuring database..."
source ./scripts/database/configure.sh

# Create namespace and label it
echo "📂 Creating namespace and labeling it..."
source ./scripts/database/namespace.sh

# Create StorageClass, PV, and PVC
echo "💾 Creating StorageClass, PV, and PVC..."
source ./scripts/database/storage.sh

# Create NetworkPolicy
echo "🔒 Creating NetworkPolicy..."
source ./scripts/database/network.sh

# Create StatefulSet
echo "🚀 Creating StatefulSet..."
source ./scripts/database/statefulset.sh

# Create Service
echo "🔌 Creating Service..."
source ./scripts/database/service.sh

# Create Ingress (if DOMAIN_NAME is provided)
if [ -n "${DOMAIN_NAME}" ]; then
    echo "🌐 Creating Ingress..."
    source ./scripts/database/ingress.sh
fi

echo "✅ Database deployment completed successfully!"