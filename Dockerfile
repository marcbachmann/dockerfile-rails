FROM ruby:2.1.5
MAINTAINER Marc Bachmann <marc.brookman@gmail.com>

WORKDIR /

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common python-software-properties build-essential \
    unzip curl wget git python

# Install app dependencies
RUN apt-get install -y imagemagick libmagickwand-dev postgresql-client
RUN git clone --depth 1 https://github.com/creationix/nvm.git /.nvm && \
    /bin/bash -c '. /.nvm/nvm.sh; nvm install v0.10.32 && nvm use v0.10.32 && nvm alias default v0.10.32 && ln -s /.nvm/v0.10.32/bin/node /usr/bin/node && ln -s /.nvm/v0.10.32/bin/npm /usr/bin/npm'

# Install redis for job queue & caching
ENV REDIS_URL redis://localhost/0
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv C7917B12 && \
    echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu quantal main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y redis-server pwgen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH
ENV GEM_PATH /usr/local/bundle
RUN /bin/bash -l -c 'gem install foreman'

RUN apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
