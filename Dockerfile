FROM centos:7

MAINTAINER Thembela Kwenene <thembela@kineticskunk.com>

RUN yum -y install openssl-devel python-devel java-1.8.0-openjdk which unzip wget epel-release kernel-headers kernel-devel && \
    yum -y groupinstall 'Development Tools' && \
    wget --no-verbose -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo && \
    wget --no-verbose -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo && \
    rpm -v --import https://jenkins-ci.org/redhat/jenkins-ci.org.key && \
    yum -y install jenkins VirtualBox-5.1 && \
    wget --no-verbose -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.9.2/terraform_0.9.2_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    wget --no-verbose -O /tmp/install-docker.sh https://get.docker.com/ && \
    bash /tmp/install-docker.sh && \
    usermod -aG vboxusers,docker jenkins && \
    wget --no-verbose -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && \
    pip install awscli virtualenv ansible && \
    wget --no-verbose -O /tmp/vagrant.rpm https://releases.hashicorp.com/vagrant/1.9.3/vagrant_1.9.3_x86_64.rpm && \
    rpm -Uvh /tmp/vagrant.rpm && \
    mkdir -m 0755 /nix && chown jenkins /nix && \
    chown -c jenkins /var/lib/jenkins && \
    chsh -s /bin/bash jenkins

USER jenkins

ENV USER jenkins

RUN vagrant box add centos/7 --provider virtualbox && \
    wget -O /tmp/nix-installer.sh https://nixos.org/nix/install && \
    bash /tmp/nix-installer.sh && \
    . /var/lib/jenkins/.nix-profile/etc/profile.d/nix.sh

CMD ["java", "-jar", "/usr/lib/jenkins/jenkins.war"]
