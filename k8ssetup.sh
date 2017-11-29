#!/bin/bash
kubectl run microgateway --image=gcr.io/project/microgteway --port=8000 --replicas=2
kubectl expose deployment microgateway --type=LoadBalancer
kubectl get services
