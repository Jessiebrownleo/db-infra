#!/bin/bash

create_statefulset() {
    STATEFULSET_TEMPLATE="/home/sen/cloudinator/templates/postgres-statefulset.yaml"
    envsubst < ${STATEFULSET_TEMPLATE} | kubectl apply -f -
}