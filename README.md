# Apigee Edge Docker Image Creation
This project describes how you can create a docker image for Apigee Edge Installation.

### Prerequisites
1. Docker
Please refer to this page to install docker in your machine
https://www.docker.com/products/docker-toolbox

### Getting Started
1. Clone the project
```git clone git@gitlab.apigee.com:rmishra/apigee-edgemicro-docker.git```
2. Switch directory
```cd apigee-edgemicro-docker```
3. Build the docker image using following command:
```docker build --build-arg ADMINUSER="trial@apigee.com" --build-arg ADMINPASSWORD="password"  --build-arg ORG=ssridhar --build-arg ENV=test -t apigee-edgemicro .```
4. This will create a image apigee-edgemicro and you can see the images using command:
```docker images```
5. To start docker
```docker run -d -P -it apigee-edge-aio```
6. To start edgemicro the following command:
```docker run -d -P -it apigee-edgemicro /bin/bash -c "edgemicro start -o ssridhar -e test -k 8b0df9aa29f8c1a35cf13ea4ea02ede95ee1acefdf9f6b6e57cfd6535b41ddba -s 5c0d061732c25fa80c7d32d943fa5dc5bdde0199e70a4317d91e6862e0de2b2c && /bin/bash"```
NOTE: The key and secret were generated in Step 3

7. To get all the docker container running
```
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                     NAMES
027907c6c5b5        apigee-edgemicro    "/bin/bash -c 'edgemi"   10 seconds ago      Up 9 seconds        0.0.0.0:32774->8000/tcp   tiny_ptolemy
```

### License
Apache 2.0
