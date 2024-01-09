FROM debian:12-slim

# RUN apt-get update -q && \
#     apt-get install -y wget lsb-release && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

USER root
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends\
    gpg dput supervisor wget curl git tzdata gnupg tor tor-geoipdb \
    debhelper net-tools software-properties-common locales\
    devscripts dh-apparmor dh-python dpkg-dev lsb-release\
    python3-all python3-pip python3-setuptools sudo\
    python3-sphinx lsb-release nodejs npm build-essential debootstrap iptables && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

WORKDIR /var/globaleaks

COPY .. /var/globaleaks
RUN chmod +x scripts/build.sh
RUN chmod +x scripts/install.sh
RUN chmod +x scripts/run-build.sh
RUN chmod +x scripts/build_and_install.sh
# RUN ./scripts/run-build.sh
RUN ./scripts/build.sh -d all

# RUN sudo -E chroot /tmp/globaleaks_chroot/ su - builduser /bin/bash -c /var/globaleaks/scripts/build_and_install.sh
 
# RUN sudo mount --rbind /proc /tmp/globaleaks_chroot/proc
# RUN sudo mount --rbind /sys /tmp/globaleaks_chroot/sys
# RUN sudo scripts/install.sh -y



# RUN wget https://deb.globaleaks.org/install-globaleaks.sh
# RUN chmod +x install-globaleaks.sh
# RUN ./install-globaleaks.sh -y -n


EXPOSE 8080
EXPOSE 8443

# USER globaleaks

CMD ["/usr/bin/python3", "/usr/bin/globaleaks", "--working-path=/var/globaleaks/", "-n"]
