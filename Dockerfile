FROM buluma/ubuntu:14.04
LABEL maintainer="Michael Buluma"

ENV pip_packages "ansible"

# Install dependencies and upgrade Python.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       locales \
       python-software-properties \
       software-properties-common \
       python3-pip python3-dev \
       python-setuptools \
       wget sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Check Pip/Python Version
RUN python --version && pip --version

# Install Ansible via Pip.
# ADD https://bootstrap.pypa.io/get-pip.py .
# RUN /usr/bin/python3.5 get-pip.py \
#  && pip3 install $pip_packages
RUN pip3 install $pip_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Workaround for pleaserun tool that Logstash uses
RUN rm -rf /sbin/initctl && ln -s /sbin/initctl.distrib /sbin/initctl

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]
