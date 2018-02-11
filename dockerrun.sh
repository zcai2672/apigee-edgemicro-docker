#!/bin/bash

docker create --name microgateway  -p 8000:8000 -p 8443:8443 -P -it microgateway -e EDGEMICRO_ORG=org -e EDGEMICRO_ENV=env -e EDGEMICRO_KEY=8xx77 -e EDGEMICRO_SECRET=1cxxc
docker start $(docker ps -aqf name=microgateway)
docker ps

