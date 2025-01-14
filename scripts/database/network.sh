#!/bin/bash

envsubst < ./templates/networkpolicy.yaml | kubectl apply -f -