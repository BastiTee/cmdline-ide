FROM ubuntu:17.10
LABEL version="0.1"
LABEL description="Command-line IDE"

# Install basic environment
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget curl vim git unzip screen mc htop psmisc \
uuid-runtime elinks lynx iputils-ping net-tools locales

# Setup and install en_US locale
RUN locale-gen "en_US.UTF-8" && dpkg-reconfigure locales && \
update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Setup working directory
RUN mkdir /work
COPY scripts/* /work

# Setup path binaries
ENV PATH \
/root/:\
$PATH

# Setup init files and rc's
# COPY resources/root/.* /root/
# COPY resources/root/mc-ini /root/.config/mc/ini
# COPY resources/root/*.sh /root/
# RUN chmod a+x /root/*.sh

# Entry point is an init-script since Docker doesn't allow service startups
# The init script takes care of starting postgres and opends.
WORKDIR /work
ENTRYPOINT bash
