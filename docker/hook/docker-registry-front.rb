
host = ENV["REDIS_HOST"] || "172.17.42.1"
port = (ENV["REDIS_PORT"] || 6379).to_i
namespace = ENV["REDIS_NAMESPACE"] || "docker-registry"
passwords_key = "#{namespace}:passwords"

salt = ENV["DIGEST_SALT"] || "deadbeaf:"

redis = Redis.new(host, port)

req = Nginx::Request.new

auth = req.headers_in["Authorization"]
if auth && /\ABasic\s+([a-zA-Z0-9\+\/]+=*)/ =~ auth
  base64 = Regexp.last_match[1]
  user, raw_pass = base64.unpack("m").first.split(":", 2)
  digest = redis.hget(passwords_key, user)
  if raw_pass
    sha1 = Digest::SHA1.hexdigest(salt+raw_pass)
  end

  if digest and digest == sha1
    #Nginx.return Nginx::HTTP_OK
  else
    req.headers_out["WWW-Authenticate"] = "Basic realm=\"nginx-docker-registry\""
    Nginx.rputs "Authorization required"
    Nginx.return Nginx::HTTP_UNAUTHORIZED
  end
else
  req.headers_out["WWW-Authenticate"] = "Basic realm=\"nginx-docker-registry\""
  Nginx.rputs "Please enter user&password"
  Nginx.return Nginx::HTTP_UNAUTHORIZED
end
