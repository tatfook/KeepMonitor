FROM jenkins/jenkins
MAINTAINER DreamAndDead <favorofife@yeah.net>

USER root

# install docker
RUN apt-get update
RUN apt-get remove docker docker.io

RUN apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88

RUN apt-get install -y lsb-release
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update

RUN apt-get install -y docker-ce
RUN apt-get autoremove
