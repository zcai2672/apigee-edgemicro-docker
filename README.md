# Apigee Edge Microgateway Docker Image Creation
This project describes how you can create a docker image for Apigee Edge Microgateway.

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

### Operationalizing Edge Microgateway (MG)
#### Configuration File
Each MG instance can expose a different set of APIs. Furthermore, each MG container can load a different set of plugins depending on the needs of the API. 

All of this is controlled via the configuration yaml file. Generate the config yaml outside of the docker image. Edit the configuration file as necessary (enable proxies, plugins etc.) before you build the docker image. You'll want to store the configuration file in a source code repo.

#### Custom plugins
If the MG instance uses custom plugins, one way is to package those custom plugins as npm modules (private repo or public repo). Then the installation of MG can be done as:
```npm install -g edgemico plugin-1 plugin-2```

#### A Sample configuration file
```
edge_config:
.
.
. omitted for brevity
edgemicro:
  port: 7000
  max_connections: 1000
  max_connections_hard: 5000
  restart_sleep: 500
  restart_max: 50
  max_times: 300
  config_change_poll_interval: 600
  logging:
    level: error
    dir: /var/tmp
    stats_log_interval: 60
    rotate_interval: 24
  plugins:
    sequence:
      - oauth
      - plugin-1
      - plugin-2
.
.
. omitted for brevity
```

### License
Apache 2.0
