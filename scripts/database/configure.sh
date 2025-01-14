#!/bin/bash

configure_database() {
    case ${DB_TYPE} in
        "mysql")
            DB_IMAGE="mysql:${DB_VERSION}"
            STATEFULSET_TEMPLATE="templates/mysql-statefulset.yaml"
            ;;
        "postgres")
            DB_IMAGE="postgres:${DB_VERSION}"
            STATEFULSET_TEMPLATE="templates/postgres-statefulset.yaml"
            ;;
        "mongodb")
            DB_IMAGE="mongo:${DB_VERSION}"
            STATEFULSET_TEMPLATE="templates/mongodb-statefulset.yaml"
            ;;
        *)
            log "❌ Unsupported database type. Use postgres, mysql, or mongodb."
            exit 1
            ;;
    esac
}