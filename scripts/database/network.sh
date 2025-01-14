#!/bin/bash

create_network_policy() {
    envsubst < templates/networkpolicy.yaml | kubectl apply -f -
}

# scripts/database/service.sh
#!/bin/bash

create_service() {
    envsubst < templates/service.yaml | kubectl apply -f -
}
