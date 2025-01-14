#!/bin/bash

create_namespace_resources() {
    kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
    kubectl label namespace ${NAMESPACE} name=${NAMESPACE} --overwrite

    if [ "${DB_TYPE}" == "mysql" ]; then
        kubectl create secret generic ${DB_NAME}-secret \
            --from-literal=MYSQL_ROOT_PASSWORD=${DB_PASSWORD} \
            --from-literal=MYSQL_USER=${DB_USERNAME} \
            --from-literal=MYSQL_PASSWORD=${DB_PASSWORD} \
            --from-literal=MYSQL_DATABASE=${DB_NAME} \
            --namespace=${NAMESPACE} \
            --dry-run=client -o yaml | kubectl apply -f -
    else
        kubectl create secret generic ${DB_NAME}-secret \
            --from-literal=${ENV_USERNAME_VAR}=${DB_USERNAME} \
            --from-literal=${ENV_PASSWORD_VAR}=${DB_PASSWORD} \
            --from-literal=${ENV_DB_VAR}=${DB_NAME} \
            --namespace=${NAMESPACE} \
            --dry-run=client -o yaml | kubectl apply -f -
    fi
}