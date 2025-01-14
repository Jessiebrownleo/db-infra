#!/bin/bash

print_deployment_summary() {
    echo "✅ Database deployment completed successfully!"
    echo ""
    echo "📊 Database Details:"
    echo "  - Name: ${DB_NAME}"
    echo "  - Type: ${DB_TYPE}"
    echo "  - Version: ${DB_VERSION}"
    echo "  - Namespace: ${NAMESPACE}"
    echo "  - Port: ${DB_PORT}"
    echo ""
    echo "🔌 Connection Information:"
    echo "  - Internal: ${DB_NAME}.${NAMESPACE}.svc.cluster.local:${DB_PORT}"
    if [ ! -z "${DOMAIN_NAME}" ]; then
        echo "  - External: ${DB_NAME}-${NAMESPACE}.${DOMAIN_NAME}"
    fi
    echo "  - NodePort: ${PORT}"
    echo "⏳ Wait for the database to be ready:"
    echo "  kubectl get pods -n ${NAMESPACE} -l app=${DB_NAME} -w"
    echo "  kubectl logs -f -n ${NAMESPACE} -l app=${DB_NAME}"
}
