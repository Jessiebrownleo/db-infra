#!/bin/bash

validate_unique_deployment() {
    log "🔍 Checking for conflicts..."
    
    if kubectl get pods -n ${NAMESPACE} -l app=${DB_NAME} 2>/dev/null | grep -q "${DB_NAME}"; then
        log "❌ Database '${DB_NAME}' already exists in namespace '${NAMESPACE}'"
        exit 1
    fi
}