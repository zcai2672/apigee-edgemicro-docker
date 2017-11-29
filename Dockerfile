FROM node:slim
ARG ADMINUSER=someuser
ARG ADMINPASSWORD=somepassword
ARG ORG=someorg
ARG ENV=someenv
ARG KEY=somekey
ARG SECRET=somesecret
RUN npm install -g edgemicro
RUN edgemicro init
ENV EDGEMICRO_ORG=$ORG
ENV EDGEMICRO_ENV=$ENV
ENV EDGEMICRO_KEY=$KEY
ENV EDGEMICRO_SECRET=$SECRET
ENV DEBUG=*
COPY $ORG-$ENV-config.yaml /root/.edgemicro
COPY entrypoint.sh /tmp
# copy tls files if needed
# COPY key.pem /root/.edgemicro
# COPY cert.pem /root/.edgemicro
EXPOSE 8000
EXPOSE 8443
ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD [""]
