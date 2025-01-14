#!/bin/bash

case ${DB_TYPE} in
    "mysql")
        envsubst < ./templates/mysql-statefulset.yaml | kubectl apply -f -
        ;;
    "postgres")
        envsubst < ./templates/postgres-statefulset.yaml | kubectl apply -f -
        ;;
    "mongodb")
        envsubst < ./templates/mongodb-statefulset.yaml | kubectl apply -f -
        ;;
esac