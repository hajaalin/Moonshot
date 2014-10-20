FROM centos:centos6

RUN yum upgrade -y
RUN yum install -y wget

# Install EPEL
RUN rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Install the Moonshot repository
ADD moonshot.repo /etc/yum.repos.d/moonshot.repo
# Install the Moonshot GPG key
RUN wget -O /etc/pki/rpm-gpg/Moonshot http://repository.project-moonshot.org/rpms/centos6/moonshot.key
# Install the Moonshot Client libraries
RUN yum install -y moonshot-gss-eap moonshot-ui

# install iRODS icommands
RUN wget -O irods.rpm https://www.tdata.fi/documents/47404/69625/irods-client-GSI-3.3.1-moonshot_2.x86_64.rpm/b09f641d-8257-4d53-aefc-b7dd029ea4d1
#RUN rpm -i irods.rpm
RUN yum install -y irods.rpm
#RUN yum install -y ftp://ftp.renci.org/pub/irods/releases/4.0.3/irods-icommands-4.0.3-64bit-centos6.rpm

RUN yum install -y \
openssh-server \
xauth \
augeas \
&& mkdir /var/run/sshd

RUN /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
RUN /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''

ENV SSHD_CONFIG /files/etc/ssh/sshd_config
RUN augtool set ${SSHD_CONFIG}/UsePAM no \
&& augtool set ${SSHD_CONFIG}/X11Forwarding yes \
&& augtool set ${SSHD_CONFIG}/X11UseLocalhost no \
&& augtool set ${SSHD_CONFIG}/KerberosAuthentication no \
&& augtool set ${SSHD_CONFIG}/GSSAPIAuthentication no

ADD irodsEnv /home/dev/.irods/.irodsEnv

# Create user. Set same UID as in data container...
RUN useradd -s /bin/bash -u 1000 dev \
&& chown -R dev: /home/dev \
&& echo 'dev:123'|chpasswd

WORKDIR /home/dev
ENV HOME /home/dev

RUN chown -R dev: /home/dev
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"] 
