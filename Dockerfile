FROM debian:12
# FROM ubuntu:24.04


RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends\
    gpg dput supervisor wget curl git tzdata gnupg tor tor-geoipdb \
    debhelper net-tools software-properties-common locales\
    devscripts dh-apparmor dh-python dpkg-dev lsb-release\
    python3-all python3-pip python3-setuptools sudo\
    python3-sphinx lsb-release nodejs npm build-essential debootstrap iptables && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

RUN apt-get dist-upgrade
# RUN wget https://deb.globaleaks.org/install-globaleaks.sh
# RUN chmod +x install-globaleaks.sh
# RUN ./install-globaleaks.sh -y -n

# COPY scripts/install.sh .
# RUN chmod +x install.sh
# RUN ./install.sh

# RUN apt-get update -q && \
#     apt-get install -y globaleaks && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*
# USER root

# Copy configs
ADD data/torrc /etc/tor/torrc
ADD data/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Tor configuration
RUN mkdir -p /var/log/tor && mkdir -p /var/log/tor
ENV TORPIDDIR=/var/run/tor
ENV TORLOGDIR=/var/log/tor
RUN mkdir -m 02755 "$TORPIDDIR" && chown root:root "$TORPIDDIR"
RUN chmod 02750 "$TORLOGDIR" && chown root:root "$TORLOGDIR"

WORKDIR /var/globaleaks

# COPY --chown=root:root . /var/globaleaks
COPY . /var/globaleaks
RUN chmod +x scripts/run-build.sh
RUN chmod +x scripts/build.sh
RUN chmod +x scripts/install.sh
RUN chmod +x scripts/build_and_install.sh

RUN update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
    # update-alternatives --set arptables /usr/sbin/arptables-legacy && \
    # update-alternatives --set netbase /usr/sbin/ebtables-legacy
# RUN ./scripts/run-build.sh

RUN ./scripts/build_and_install.sh
# RUN sudo ./scripts/install.sh -y -n

RUN wget https://deb.globaleaks.org/install-globaleaks.sh

# RUN chmod +x install-globaleaks.sh

RUN chown root:root install-globaleaks.sh
RUN chmod 4755 install-globaleaks.sh

RUN ./install-globaleaks.sh -y -n



# RUN useradd -m globaleaks && echo "globaleaks:globaleaks" | chpasswd && adduser globaleaks sudo

EXPOSE 8080
EXPOSE 8443

# USER globaleaks

USER root

# Docker volume for persistent data
VOLUME [ "/var/globaleaks/" ]

CMD ["/usr/bin/python3", "/usr/bin/globaleaks", "--working-path=/var/globaleaks/", "-n"]


# Run supervisord
# CMD ["/usr/bin/supervisord"]