FROM debian:12-slim

RUN apt-get update -q && \
    apt-get -y install gpg supervisor wget curl git tzdata gnupg \
    debhelper net-tools software-properties-common locales\
    devscripts dh-apparmor dh-python dpkg-dev lsb-release\
    python3-all python3-pip python3-setuptools sudo\
    python3-sphinx lsb-release nodejs npm build-essential debootstrap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
# RUN ./scripts/run-build.sh

RUN ./scripts/build.sh

# RUN useradd -m globaleaks && echo "globaleaks:globaleaks" | chpasswd && adduser globaleaks sudo

EXPOSE 8080
EXPOSE 8443

# USER globaleaks

# CMD ["/usr/bin/python3", "/usr/bin/globaleaks", "--working-path=/var/globaleaks/", "-n"]

# Docker volume for persistent data
VOLUME [ "/var/globaleaks/" ]

# Run supervisord
CMD ["/usr/bin/supervisord"]