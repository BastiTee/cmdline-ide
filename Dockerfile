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

# Copy and setup bastis bash commons
RUN mkdir -p /bbc
COPY lib/bastis-bash-commons/bbc* /bbc/
RUN chmod a+x /bbc/bbc*
COPY res/bashrc /root/.bashrc

# Copy and setup shell rcs
COPY lib/ubersettings/shell-rcs/.* /root/
RUN mkdir -p /root/.config/mc
COPY lib/ubersettings/shell-rcs/ini /root/.config/mc/

# Setup working environment
ENV PATH /root/:/bbc/:$PATH
RUN mkdir -p /work

# Entry point is an init-script since Docker doesn't allow service startups
# The init script takes care of starting postgres and opends.
WORKDIR /work
ENTRYPOINT bash
#ENTRYPOINT screen
