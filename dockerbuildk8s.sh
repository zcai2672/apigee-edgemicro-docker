#!/bin/bash

docker build --build-arg ORG="org" --build-arg ENV="env" -t microgateway .
docker tag microgateway:latest gcr.io/$PROJECT_ID/microgateway:latest
gcloud docker -- push gcr.io/$PROJECT_ID/microgateway:latest
