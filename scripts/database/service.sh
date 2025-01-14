#!/bin/bash

create_service() {
    envsubst < templates/service.yaml | kubectl apply -f -
}