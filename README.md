# Apigee Edge Docker Image Creation
This project describes how you can create a docker image for Apigee Edge Installation.

### Prerequisites
1. Docker
Please refer to this page to install docker in your machine
https://www.docker.com/products/docker-toolbox

### Pre-requisites
[outside of docker]
1. Install Edge microgateway
```npm install -g edgemicro```
2. Initialize Edge microgateway
```edgemicro init```
3. Configure Edge microgateway
```edgemicro configure -o "your-orgname" -e "your-envname" -u "your-username"```
NOTE: OPDK users should use "edgemicro private configure".

At the end of a successful configuration, you will see a file in the ~/.edgemicro/{org}-{env}-config.yaml as well as a key and secret. The key maps to EDGEMICRO_KEY and the secret maps to EDGEMICRO_SECRET in the following section.

### Getting Started
1. Clone the project
```git clone https://github.com/srinandan/apigee-edgemicro-docker.git```
2. Switch directory
```cd apigee-edgemicro-docker```
4. Copy the {org}-{env}-config.yaml to the current folder (from pre-reqs). Edit the Dockerfile with the correct file name.
5. Build the docker image using following command:
```docker build --build-arg ORG="your-orgname" --build-arg ENV="your-env" --build-arg KEY="bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx2" --build-arg SECRET="exxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0" -t microgateway .```
6. This will create a image apigee-edgemicro and you can see the images using command:
```docker images```
7. To start docker
```docker run -d -p 8000:8000 -e EDGEMICRO_ORG="your-orgname" -e EDGEMICRO_ENV="your-env" -e EDGEMICRO_KEY="bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx2" -e  EDGEMICRO_SECRET="exxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0" -P -it microgateway```

### License
Apache 2.0
