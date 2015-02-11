# nginx-docker-registry

Docker imgage of nginx reversse proxy for [docker-registry](https://github.com/docker/docker-registry).

- Add Basic Authentication
  - account information derived from Redis
- Access control

## TODO

- TLS support
- performance tuning

## Quick Start

1. start containers

```
$ git clone git@github.com:nagachika/nginx-docker-registry.git
$ cd nginx-docker-registry/
$ dockre run -d -p 6379:6379 redis:latest
$ docker run -d -p 5000:5000 registry
$ docker build nginx-docker-registry .
$ docker run -d -p 80:80 -p 443:443 -e REDIS_HOST=172.17.42.1 -e DIGEST_SALT=salt nginx-docker-registry
```

2. prepare account information & proxy backend

```
# get digest string for the password
$ ruby -rdigest -e 'puts Digest::SHA1.hexdigest("salt:password")'
(copy digest string)
$ redis-cli
> hset docker-registry:passwords user1 (copied digest string)
> lpush docker-registry:backends 172.17.42.1:5000
```


