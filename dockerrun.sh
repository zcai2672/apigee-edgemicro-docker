#!/bin/bash

docker create --name microgateway  -p 8000:8000 -p 8443:8443 -P -it microgateway -e EDGEMICRO_ORG=amer-demo13 -e EDGEMICRO_ENV=test -e EDGEMICRO_KEY=8ad8c5441c3d4897ba5475f6de0006fefc781c27133f9a6ed91cce1739932877 -e EDGEMICRO_SECRET=1cf037c1f5ab4fbd7c8d137c4af77af0064e035023ade3c4071ad38f78a47a0c
docker start $(docker ps -aqf name=microgateway)
docker ps

