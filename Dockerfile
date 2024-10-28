FROM jenkins/jenkins:2.482-jdk17

USER root

# bootstrap
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install \
      sudo \
      python3 \
      python3-pip \
      python3-venv \
      jq \
      uuid-runtime \
      wget

# docker
RUN apt-get update && apt-get install -y apt-transport-https \
      ca-certificates curl gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y docker-ce-cli docker-compose

# CASC
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
