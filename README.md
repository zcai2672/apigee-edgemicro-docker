# Apigee Edge Microgateway on Docker & Kubernetes
This project describes how you can Apigee Edge Microgateway on Kubernetes.

### Prerequisites
1. Docker
Please refer to this page to install docker in your machine
https://www.docker.com/products/docker-toolbox
2. Node.js 4.x or later, for more info visit https://github.com/nodejs/Release
3. Basic understanding and experience with Docker
4. If you choose to in a Kubernetes environment, you will need to have some experience with Kubernetes


### Pre-requisites
[outside of docker]
1. Install Edge microgateway
```npm install -g edgemicro```
2. Initialize Edge microgateway
```edgemicro init```
3. Configure Edge microgateway
```edgemicro configure -o "your-orgname" -e "your-envname" -u "your-username"``` when the configuration is successful, you will see the key and secret credentials displayed, save it to a note for later use. 
NOTE: OPDK users should use "edgemicro private configure".

At the end of a successful configuration, you will see a file in the ~/.edgemicro/{org}-{env}-config.yaml as well as a key and secret. The key maps to EDGEMICRO_KEY and the secret maps to EDGEMICRO_SECRET in the following section.


### Option 1 - Docker only deployment

You can set this up in your desktop environment. 

1. Clone the project
```git clone https://github.com/zcai2672/apigee-edgemicro-docker.git```
2. Switch directory
```cd apigee-edgemicro-docker```
4. Copy the {org}-{env}-config.yaml to the current folder (from pre-reqs). Edit the Dockerfile with the correct file name.
5. Build the docker image using following command:
```docker build --build-arg ORG="your-orgname" --build-arg ENV="your-env" -t microgateway .```
6. This will create a image apigee-edgemicro and you can see the images using command:
```docker images```
7. To start docker
```docker run -d -p 8000:8000 -e EDGEMICRO_ORG="your-orgname" -e EDGEMICRO_ENV="your-env" -e EDGEMICRO_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -e  EDGEMICRO_SECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -P -it microgateway```

8. To test ``` curl http://localhost:8000/hello/echo ```
    you should see something like this
    ```
    {"error":"missing_authorization","error_description":"Missing Authorization header"}
    ```    


### Option 2 - Docker in GCP Kubenetes deployment 

You will need to a Google Cloud platform Account for this option. A local Kubernetes installation might also work but has not been tested at this stage. 

1. Login to your GCP console, create your Kubernetes cluster under Kubernetes Engine. 

2. Clone the project
```git clone https://github.com/zcai2672/apigee-edgemicro-docker.git```
3. Switch directory
```cd apigee-edgemicro-docker```
4. Copy the {org}-{env}-config.yaml to the current folder (from pre-reqs). Edit the Dockerfile with the correct file name.
5. Build the docker image using following command:
    ```
    docker build --build-arg ORG="your-orgname" --build-arg ENV="your-env" --build-arg KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" --build-arg SECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -t microgateway .
    ```

6. This will create a image apigee-edgemicro and you can see the images using command:
```docker images```

7. (Optional) If the MG instance uses custom plugins, one way is to package those custom plugins as npm modules (private repo or public repo). Then the installation of MG can be done as:

   ```
   npm install -g edgemico plugin-1 plugin-2
   ``` 
    Edit the configuration file ( {org}-{env}-config.yaml )
   ```
    plugins:
    sequence:
      - oauth
      - plugin-1
      - plugin-2
    .
    .
    . omitted for brevity
    ```

8. (Optional) A different set of APIs can be created for different instances by using proxyPattern inside the edge_config member
    ```
    edge_config:
      proxyPattern: edgemicro_part_1*
      .
      .
      . omitted for brevity
    ```

    For more reference please see **Filtering downloaded proxies** section [here](https://docs.apigee.com/api-platform/microgateway/2.5.x/operation-and-configuration-reference-edge-microgateway)


9.  Prepare the docker images registraton

    In the Kubernetes terminal run:
    ```
    export PROJECT_ID=xxxx
    ```
    Tag the docker image (GCR)

    ```
    docker tag microgateway gcr.io/$PROJECT_ID/microgateway:latest
     ```

10. Create Kubernetes secret
    * Convert EdgeMicro credentials to base64
Convert each of these values into base64. THis will help store those credentails into k8s secrets.
      ```
      echo -n "org" | base64
      echo -n "env" | base64
      echo -n "key" | base64
      echo -n "secret" | base64
      ```
    * Use the results in the configuration in the mgw-secret.yaml

      ```
      apiVersion: v1
      kind: Secret
      metadata:
        name: mgwsecret
      type: Opaque
      data:
        mgorg: xxxxxx
        mgenv: xxxxxx
        mgkey: xxxxxx
        mgsecret: xxxxxx
      ```
       Run this file in your kubernetes environment to create the secret configuration
       ``` 
       kubectl create -f  mgw-secret.yaml
       ```
      for more info on Kubernetes secrets please visit the [here](https://kubernetes.io/docs/concepts/configuration/secret/)
     
      You can check if the secret creation by issuring the following command
      ```
      kubectl get secrets
      ```
      You will see something similar to this:

      ```
      NAME           TYPE       DATA      AGE
      mgwsecret      Opaque     4         23h
      ```

      
11. Create Kubernetes microgateway pod

    Fill in the 'image' member to point to the correct docker container registry location (In Step 8) in the mgw-pod.yaml
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: edge-microgateway
      labels:
        app: edge-microgateway 
    spec:
      restartPolicy: Never
      containers:
        - name: edge-microgateway
          # Need to update
          image: gcr.io/$PROJECT_ID/microgateway:latest 
          ports:
            - containerPort: 8000
          env:
            - name: EDGEMICRO_ORG
              valueFrom:
                secretKeyRef:
                  name: mgwsecret
                  key: mgorg
            - name: EDGEMICRO_ENV
              valueFrom:
                secretKeyRef:
                  name: mgwsecret
                  key: mgenv
            - name: EDGEMICRO_KEY
              valueFrom:
                secretKeyRef:
                  name: mgwsecret
                  key: mgkey
            - name: EDGEMICRO_SECRET
              valueFrom:
                secretKeyRef:
                  name: mgwsecret
                  key: mgsecret
            - name: EDGEMICRO_CONFIG_DIR
              value: /home/microgateway/.edgemicro    
    ```
    Run the script to create the pod
    ```
    kubectl create -f mgw-pod.yaml
    ```

    Check if the pod has been created
    ```
    kubectl get pods
    ```
    You will see something like this: 
    ```
    NAME                            READY     STATUS    RESTARTS   AGE
    edge-microgateway               1/1       Running   0          17h
    ```  

    

12. Create Kubernetes microgateway Service to expose the gateway

    Make sure that your selector is configured to point to the pod labels member from the step above. 
    ```
    apiVersion: v1
    kind: Service
    metadata:
      name: edge-microgateway
      labels:
        app: edge-microgateway
    spec:
      ports:
      - port: 8000
        name: http
      selector:
        app: edge-microgateway

    ```
    Check if service has been created 

    ```
    kubectl get services 
    ```
    You should see something like this: 
    ```
    NAME                TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
    edge-microgateway   LoadBalancer   xx.xx.xx.xx     xx.xx.xx.xx     8000:31827/TCP   17h
    kubernetes          ClusterIP      10.59.240.1     <none>          443/TCP          1d
    ```


    Test via curl using the generated external ip, please make sure that your endpoint is valid
    ```
    curl -v http://<EXTERNAL-IP>:8000/hello/echo -v
    ```
    You should be see something like this:


    ```
    {"error":"missing_authorization","error_description":"Missing Authorization header"}
    ```


