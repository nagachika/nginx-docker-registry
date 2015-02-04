# nginx-docker-registry

Docker container of nginx for docker-registry.

- Add Basic Authentication
- Authentication info user/password) from Redis
- Access control for repository namespace

## Quick Start

```
$ docker run -d -p 5000:5000 registry
$ docker build nginx-docker-registry .
$ docker run -d -p 80:80 -p 443:443 -e NGINX_DOCKER_REGISTRY_BACKEND=http://localhost:5000 nginx-docker-registry
```
