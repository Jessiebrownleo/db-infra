#!/bin/bash

validate_inputs() {
    local DB_NAME=$1
    local DB_TYPE=$2
    local DB_VERSION=$3

    if [ -z "${DB_NAME}" ] || [ -z "${DB_TYPE}" ] || [ -z "${DB_VERSION}" ]; then
        echo "❌ Error: DB_NAME, DB_TYPE, and DB_VERSION are required."
        exit 1
    fi

    if [[ "${DB_TYPE}" != "mysql" && "${DB_TYPE}" != "postgres" && "${DB_TYPE}" != "mongodb" ]]; then
        echo "❌ Error: Unsupported database type. Use 'mysql', 'postgres', or 'mongodb'."
        exit 1
    fi
}