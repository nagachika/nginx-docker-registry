FROM nagachika/ngx-mruby:ssl

MAINTAINER nagachika@ruby-lang.org

ADD docker/conf/docker-registry.conf /usr/local/nginx/conf/docker-registry.conf

VOLUME ["/usr/local/nginx/ssl"]
