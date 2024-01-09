FROM debian:12

RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends\
    gpg dput supervisor wget curl git tzdata tor tor-geoipdb \
    debhelper net-tools software-properties-common \
    devscripts dh-apparmor dh-python lsb-release\
    python3-all python3-pip python3-setuptools\
    python3-sphinx lsb-release nodejs npm build-essential debootstrap iptables

RUN add-apt-repository ppa:deadsnakes/ppa 
RUN apt-get install -y python3.9 && apt-get install python3-pip

WORKDIR /var/globaleaks

COPY . /var/globaleaks
RUN chmod +x scripts/entrypoint.sh 

EXPOSE 80
EXPOSE 8080
EXPOSE 8443

RUN ./scripts/entrypoint.sh