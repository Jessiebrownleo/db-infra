#!/bin/bash

create_ingress() {
    if [ ! -z "${DOMAIN_NAME}" ]; then
        envsubst < templates/ingress.yaml | kubectl apply -f -
    fi
}
