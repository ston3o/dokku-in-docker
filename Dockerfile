FROM phusion/baseimage:latest

ENV DOKKU_VERSION v0.10.3
ENV GOLANG_VERSION 1.7.5

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
RUN locale-gen en_US.*

RUN apt-get update --fix-missing
RUN apt-get install -y git make curl software-properties-common sudo wget man openssh-server nginx help2man dnsutils apt-transport-https ca-certificates curl lxc iptables net-tools dmsetup
    
# Install dokku
RUN wget -qO /tmp/go${GOLANG_VERSION}.linux-amd64.tar.gz https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && tar -C /usr/local -xzf /tmp/go${GOLANG_VERSION}.linux-amd64.tar.gz
RUN mkdir -p /go/src/github.com/dokku/ && \
    git clone https://github.com/progrium/dokku /go/src/github.com/dokku/dokku && \
    cd /go/src/github.com/dokku/dokku && \
    git checkout ${DOKKU_VERSION}
RUN cd /go/src/github.com/dokku/dokku && \
    make sshcommand plugn sigil version && \
    export PATH=$PATH:/usr/local/go/bin && \
    export GOPATH=/go && \
    make copyfiles PLUGIN_MAKE_TARGET=build
RUN dokku plugin:install-dependencies --core
RUN useradd -ms /bin/bash syslog
RUN dokku plugin:install --core

# Install docker
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker dokku

# Install the magic wrapper.
RUN mkdir /etc/service/wrapdocker
COPY build/wrapdocker.sh /etc/service/wrapdocker/run
RUN chmod +x /etc/service/wrapdocker/run

# Define additional metadata for our image.
VOLUME /var/lib/docker

# SSH
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Nginx
RUN mkdir /etc/service/nginx
COPY build/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# Startup
RUN mkdir -p /etc/service/startup/
COPY build/startup.sh /etc/service/startup/run
RUN chmod +x /etc/service/startup/run
RUN touch /root/.firstrun

CMD ["/sbin/my_init"]
