#!/bin/bash

create_network_policy() {
    envsubst < templates/networkpolicy.yaml | kubectl apply -f -
}

create_ingress() {
    if [ ! -z "${DOMAIN_NAME}" ]; then
        envsubst < templates/ingress.yaml | kubectl apply -f -
    fi
}