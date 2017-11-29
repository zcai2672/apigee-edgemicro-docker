#!/bin/bash

docker build --build-arg ORG="org" --build-arg ENV="env" --build-arg KEY="8axxx7" --build-arg SECRET="1cxxx0c" -t microgateway .
