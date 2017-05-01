FROM node:slim
ARG ADMINUSER=someuser
ARG ADMINPASSWORD=somepassword
ARG ORG=someorg
ARG ENV=someenv
ARG KEY=somekey
ARG SECRET=somesecret
RUN npm install -g edgemicro
RUN edgemicro init
RUN export EDGEMICRO_ORG=$ORG
RUN export EDGEMICRO_ENV=$ENV
RUN export EDGEMICRO_KEY=$KEY
RUN export EDGEMICRO_SECRET=$SECRET
RUN export DEBUG=*
COPY $ORG-$ENV-config.yaml /root/.edgemicro
# copy tls files if needed
# COPY key.pem /root/.edgemicro
# COPY cert.pem /root/.edgemicro
CMD ["/bin/bash", "-c","edgemicro start"]
EXPOSE 8000
