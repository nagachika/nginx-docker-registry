
host = ENV["REDIS_HOST"] || "172.17.42.1"
port = (ENV["REDIS_PORT"] || 6379).to_i
namespace = ENV["REDIS_NAMESPACE"] || "docker-registry"
backends_key = "#{namespace}:backends"

redis = Redis.new(host, port)

backends = redis.lrange(backends_key, 0, -1)
backends[rand(backends.length)]
