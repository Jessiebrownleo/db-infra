#!/bin/bash

if [ -n "${DOMAIN_NAME}" ]; then
    envsubst < ./templates/ingress.yaml | kubectl apply -f -
fi