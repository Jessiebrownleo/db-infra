#!/bin/bash

create_network_policy() {
    envsubst < "/home/sen/cloudinator/templates/networkpolicy.yaml" | kubectl apply -f -
}

create_ingress() {
    if [ ! -z "${DOMAIN_NAME}" ]; then
        envsubst < "/home/sen/cloudinator/templates/ingress.yaml" | kubectl apply -f -
    fi
}