#
# Author:: Christian Trabold <christian.trabold@dkd.de>
# Cookbook Name:: redis
# Recipe:: package
#
# Copyright 2011, dkd Internet Service GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apt"

apt_repository "REDIS_PPA" do
  uri "http://ppa.launchpad.net/chris-lea/redis-server/ubuntu"
  distribution "precise"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

package "redis-server"

service "redis" do
  start_command "/etc/init.d/redis-server start #{node['redis']['config_path']}"
  stop_command "/etc/init.d/redis-server stop"
  restart_command "/etc/init.d/redis-server restart"
  action :start
end

template "/etc/redis/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "redis")
end
