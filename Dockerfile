FROM ubuntu:14.04
MAINTAINER Marc Bachmann <marc.bachmann@suitart.com>

WORKDIR /
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# To prevent front end warnings
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && \
    apt-get install -y software-properties-common build-essential unzip curl wget git python

# Add all required repositories
RUN add-apt-repository ppa:rwky/redis && \
    add-apt-repository ppa:brightbox/ruby-ng-experimental && \
    apt-get update -q

#
# Install app dependencies
#
RUN apt-get install -y imagemagick libmagickwand-dev postgresql-9.3 postgresql-server-dev-9.3
RUN git clone --depth 1 https://github.com/creationix/nvm.git /.nvm && \
    /bin/bash -c '. /.nvm/nvm.sh; nvm install v0.10.32 && nvm use v0.10.32 && nvm alias default v0.10.32 && ln -s /.nvm/v0.10.32/bin/node /usr/bin/node && ln -s /.nvm/v0.10.32/bin/npm /usr/bin/npm'

# Install redis for job queue & caching
RUN apt-get install -y redis-server
ENV REDIS_URL redis://localhost/0

# Ruby bundler dependencies
RUN apt-get install -y ruby2.1 ruby2.1-dev
# RUN  apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN /bin/bash -l -c 'gem install bundler rdoc foreman --no-ri --no-rdoc'
RUN mkdir /gems && chmod 777 /gems
ENV GEM_HOME /gems

# Add app user
ADD ./ /app
RUN useradd -ms /bin/bash app
USER app
WORKDIR /app
EXPOSE 8080
ENV PORT 8080

VOLUME  ["/app", "/data", "/gems"]

