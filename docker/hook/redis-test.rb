host = ENV["REDIS_HOST"] || "192.168.59.103"
port = (ENV["REDIS_PORT"] || 6379).to_i

redis = Redis.new(host, port)

req = Nginx::Request.new

params = Hash[req.args.split("&").map{|i| i.split("=", 2) }]

if params["key"]
  if params["value"]
    redis.set(params["key"], params["value"])
    Nginx.echo "set #{params["key"]} = #{params["value"]}"
  else
    Nginx.echo "#{params["key"]} : #{redis.get(params["key"])}"
  end
else
  Nginx.echo "randomkey: #{redis.randomkey}"
end
Nginx.return Nginx::HTTP_OK
