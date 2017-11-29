#!/bin/bash

kubectl create -f microgw.yaml --validate=true --dry-run=false

#kubectl expose deployment edge-microgateway --type=LoadBalancer
