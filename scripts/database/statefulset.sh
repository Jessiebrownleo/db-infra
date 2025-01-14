#!/bin/bash

create_statefulset() {
    envsubst < ${STATEFULSET_TEMPLATE} | kubectl apply -f -
}