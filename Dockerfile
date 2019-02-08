FROM srinivasachalla/docker-ubuntu
#FROM amd64/ubuntu
MAINTAINER Gouranga Murari <gouranga.murari@sap.com>

## Install wget
RUN apt-get update && \
    apt-get install wget

# Install and configure Redis 4.0
RUN cd /tmp && \
    wget http://download.redis.io/releases/redis-4.0.11.tar.gz && \
    tar xzvf redis-4.0.11.tar.gz && \
    cd redis-4.0.11 && \
    make && \
    make install && \
    mkdir -p /etc/redis && \
    cp -f *.conf /etc/redis && \
    sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
    apt-get install --yes runit && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN sed -i 's/bind 127.0.0.1/# bind 127.0.0.1/' /etc/redis/redis.conf && \
    sed -i 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf
## remove wget
RUN apt-get remove wget -y

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 6379

# Expose our data
VOLUME ["/data"]
