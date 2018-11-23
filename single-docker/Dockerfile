FROM amazonlinux:latest
RUN bash
RUN yum install epel-release -y
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN export PATH=~/.local/bin:$PATH
RUN python get-pip.py --user
RUN yum install ansible --enablerepo=epel -y
RUN ~/.local/bin/pip install boto
RUN ~/.local/bin/pip install awscli --upgrade
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
