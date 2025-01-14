#!/bin/bash

create_statefulset() {
    case ${DB_TYPE} in
        "mysql")
            template="templates/mysql-statefulset.yaml"
            ;;
        "postgres")
            template="templates/postgres-statefulset.yaml"
            ;;
        "mongodb")
            template="templates/mongodb-statefulset.yaml"
            ;;
    esac
    
    envsubst < ${template} | kubectl apply -f -
}