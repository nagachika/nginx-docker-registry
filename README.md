# nginx-docker-registry

Docker imgage of nginx reversse proxy for [docker-registry](https://github.com/docker/docker-registry).

- Add Basic Authentication
  - account information derived from Redis
- Access control
- SSL endpoint

## TODO

- performance tuning

## Quick Start

1. clone and prepare certicate files

```
$ git clone git@github.com:nagachika/nginx-docker-registry.git
$ cd nginx-docker-registry/
$ mkdir ssl
$ cd ssl
$ echo 01 > ca.srl
$ openssl genrsa -des3 -out ca-key.pem 2048
$ openssl req -new -x509 -days 365 -key ca-key.pem -out ca.pem
$ openssl genrsa -des3 -out docker-registry-key.pem 2048
$ openssl req -subj '/CN=<Your Hostname Here>' -new -key docker-registry-key.pem -out server.csr
$ openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -out docker-registry-cert.pem
$ openssl rsa -in docker-registry-key.pem -out docker-registry-key.pem
$ cd ../
```

2. start containers

```
$ dockre run -d -p 6379:6379 redis:latest
$ docker run -d -p 5000:5000 registry
$ docker build nginx-docker-registry .
$ docker run -d -v `pwd`/ssl  -p 443:443 -e REDIS_HOST=172.17.42.1 -e DIGEST_SALT=salt nginx-docker-registry
```

3. prepare account information & proxy backend

```
# get digest string for the password
$ ruby -rdigest -e 'puts Digest::SHA1.hexdigest("salt:password")'
(copy digest string)
$ redis-cli
> hset docker-registry:passwords user1 (copied digest string)
> lpush docker-registry:backends 172.17.42.1:5000
```


