FROM rhel

RUN echo "[Artifactory]" >> /etc/yum.repos.d/artifactory.repo && \
    echo "name=Artifactory" >> /etc/yum.repos.d/artifactory.repo && \
    echo "baseurl=https://artifactory.intra.bec.dk/artifactory/fedora-epel-rpm-release-remote/7/x86_64" >> /etc/yum.repos.d/artifactory.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/artifactory.repo && \
    echo "gpgcheck=0" >> /etc/yum.repos.d/artifactory.repo

RUN yum install -y ansible && \
    yum -y install python-pip && \
    yum install gcc -y && \
    yum install python-devel -y && \
    yum clean all -y

RUN pip install Jinja2 && pip show Jinja2

#RUN useradd -ms /bin/bash demo
#RUN echo demo:demo | chpasswd

ENV APP_ROOT=/ansible
ENV ANSIBLE_LOCAL_TEMP=${APP_ROOT}/ansible_temp
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
ENV IBM_DB_HOME=/ansible/db2_client/clidriver




RUN mkdir -p ${APP_ROOT}/ansible_temp && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g+rw,o+rw,o+rw ${APP_ROOT} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chmod -R g=u /etc/passwd /etc/group
#chmod -R g=u ${APP_ROOT}



RUN ansible --version
RUN id


USER 1001
WORKDIR ${APP_ROOT}


CMD exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"
