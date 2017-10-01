FROM jenkins
USER 0
RUN apt-get update ; yes | apt-get --yes install sudo && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.11.1.tgz && sudo tar zxf docker-1.11.1.tgz -C / && mv /docker/* /usr/bin/
RUN curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN chmod 600 /etc/sudoers ; echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
#RUN pip install awscli
#RUN pip install virtualenv

RUN mkdir -p /var/jenkins_home/.aws
COPY ["credentials", "/var/jenkins_home/.aws/credentials"]
COPY ["config", "/var/jenkins_home/.aws/config"]

COPY ["entrypoint.sh", "/"]
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]
