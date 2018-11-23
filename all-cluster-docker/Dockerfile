FROM amazonlinux:latest

RUN bash
RUN yum install epel-release -y
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN export PATH=~/.local/bin:$PATH
RUN python get-pip.py --user
RUN yum install ansible --enablerepo=epel -y
RUN ~/.local/bin/pip install boto
RUN ~/.local/bin/pip install awscli --upgrade
RUN yum install git wget -y
RUN mkdir -m 700 /root/.ssh
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY id_rsa /root/.ssh/
COPY known_hosts /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 644 /root/.ssh/id_rsa.pub
RUN chmod 644 /root/.ssh/known_hosts
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
