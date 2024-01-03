FROM debian:12-slim

RUN apt-get update -q && \
    apt-get install -y wget lsb-release && \
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

WORKDIR /var/globaleaks

COPY .. /var/globaleaks
RUN /var/globaleaks/scripts/build.sh -d all -l

EXPOSE 8080
EXPOSE 8443

USER globaleaks

# CMD ["/usr/bin/python3", "/usr/bin/globaleaks", "--working-path=/var/globaleaks/", "-n"]
