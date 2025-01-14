#!/bin/bash

create_service() {
    envsubst < "/home/sen/cloudinator/templates/service.yaml" | kubectl apply -f -
}