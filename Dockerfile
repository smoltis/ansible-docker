FROM centos/python-38-centos7
LABEL source "https://github.com/smoltis/ansible-playbook"
ENV ANSIBLE_VERSION 2.10.5

USER root

RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip sshpass tzdata

RUN set -x && \
    \
    echo "--> Getting Pip ready"  && \
    mkdir -p /etc/ansible/ && \
    pip install pip --upgrade \
    pip install --upgrade pycrypto cryptography
RUN pip install ansible==${ANSIBLE_VERSION}

RUN set -x && \
    echo "--> Cleaning up..."  && \
    rm -rf /var/cache/apk/* && \
    rm -rf /ansible/docs /ansible/examples /ansible/packaging

RUN set -x && \
    echo "--> Modifying hosts"  && \
    mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost ansible_connection=local" >> /etc/ansible/hosts

RUN mkdir -p /var/log/ansible && \
    chown 1001:1001 /var/log/ansible

USER 1001

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library
ENV ANSIBLE_SCP_IF_SSH True
ENV ANSIBLE_LOG_PATH=/var/log/ansible/ansible.log

WORKDIR /ansible
RUN ["touch", "/var/log/ansible/ansible.log"]
CMD ["ansible-playbook"]