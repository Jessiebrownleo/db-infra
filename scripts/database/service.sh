#!/bin/bash

envsubst < ./templates/service.yaml | kubectl apply -f -