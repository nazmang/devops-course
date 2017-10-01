FROM jenkins
USER root
RUN apt-get update ; yes | apt-get --yes install sudo && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.11.1.tgz && sudo tar zxf docker-1.11.1.tgz -C / && mv /docker/* /usr/bin/
RUN curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN chmod 600 /etc/sudoers ; echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
COPY ["entrypoint.sh", "/"]
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]
