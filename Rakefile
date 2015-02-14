# coding: utf-8

require "shellwords"

begin
  pid = Process.spawn("boot2docker", "version", out: File::NULL, err: File::NULL)
  _, status = Process.waitpid2(pid)
  if status.exitstatus == 0
    Boot2docker = true
  else
    Boot2docker = false
  end
rescue Errno::ENOENT
  Boot2docker = false
end

def username
  "nagachika"
end

def image_name(tag=nil)
  ["#{username}/nginx-docker-registry", tag].compact.join(":")
end

def container_name(tag="latest")
  "nginx-docker-registry-#{tag}"
end

def current_version
  File.read("VERSION").strip
end

def docker(*args)
  if Boot2docker
    cmdary = ["docker"]
  else
    cmdary = ["sudo", "docker"]
  end
  cmd = Shellwords.join(cmdary + (args.map{|s| Shellwords.escape(s)}))
  sh cmd do |ok, status|
    unless ok
      if Thread.current[:ignore_command_error]
        $stderr.puts "WARN: docker command failed with status:#{status.exitstatus}: [#{cmd}]"
      else
        raise "docker command failed with status:#{status.exitstatus}: [#{cmd}]"
      end
    end
  end
end

def ignore_error(&blk)
  orig, Thread.current[:ignore_command_error] = Thread.current[:ignore_command_error], true
  begin
    yield
  ensure
    Thread.current[:ignore_command_error] = orig
  end
end

def build(tag)
  docker "build", "-t", image_name(tag), "."
end

def push(tag)
  docker "push", image_name(tag)
end

namespace :build do
  desc "build latest docker image"
  task :latest do
    build "latest"
  end

  desc "build docker image with tag derived from VERSION file"
  task :head do
    build current_version
  end
end

namespace :push do
  desc "push latest docker image"
  task :latest do
    push "latest"
  end

  desc "push docker image with tag derived from VERSION file"
  task :head do
    push current_version
  end
end

desc "rebuild & stop & rm & run latest image"
task :reload do
  build "latest"
  ignore_error do
    docker "stop", container_name("latest")
    docker "rm", container_name("latest")
  end
  docker *%W{run -d --volume #{__dir__}/ssl:/usr/local/nginx/ssl --name #{container_name("latest")} -p 443:443 #{image_name("latest")}}
end

namespace :tail do
  desc "tail nginx error.log"
  task :error do
    docker *%w{exec -it #{container_name("latest")} tail -f /usr/local/nginx/logs/error.log}
  end

  desc "tail nginx access.log"
  task :access do
    docker *%w{exec -it #{container_name("latest")} tail -f /usr/local/nginx/logs/access.log}
  end
end
