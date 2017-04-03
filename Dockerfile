FROM node:slim
ARG ADMINUSER=someuser
ARG ADMINPASSWORD=somepassword
ARG ORG=someorg
ARG ENV=someenv
RUN npm install -g edgemicro
RUN edgemicro init
RUN edgemicro configure -o $ORG -e $ENV -u $ADMINUSER -p $ADMINPASSWORD
# replace this with your application's default port
EXPOSE 8000
