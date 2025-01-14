#!/bin/bash

log() {
    echo "$1"
}

print_deployment_details() {
    log "📊 Database Details:"
    log "  - Name: ${DB_NAME}"
    log "  - Type: ${DB_TYPE}"
    log "  - Version: ${DB_VERSION}"
    log "  - Namespace: ${NAMESPACE}"
    log "  - Port: ${DB_PORT}"
    log ""
    log "🔌 Connection Information:"
    log "  - Internal: ${DB_NAME}.${NAMESPACE}.svc.cluster.local:${DB_PORT}"
    if [ ! -z "${DOMAIN_NAME}" ]; then
        log "  - External: ${DB_NAME}-${NAMESPACE}.${DOMAIN_NAME}"
    fi
    log "  - NodePort: ${PORT}"
    log "⏳ Wait for the database to be ready:"
    log "  kubectl get pods -n ${NAMESPACE} -l app=${DB_NAME} -w"
    log "  kubectl logs -f -n ${NAMESPACE} -l app=${DB_NAME}"
}