#
# Cookbook Name:: myface
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
case node[:platform]
when 'debian', 'ubuntu'
  execute "apt-get-update-periodic" do
    command "apt-get update"
    ignore_failure true
    action :nothing
  end.run_action(:run)
end

# group node['myface']['group']

# user node['myface']['user'] do
# 	group node['myface']['group']
# 	system true
# 	shell '/bin/bash'
# end
# include_recipe 'apt'
# include_recipe 'jetty'
include_recipe 'curl'
include_recipe 'python'

include_recipe 'chef-android-sdk::default'

# case node[:platform]
# when 'redhat', 'centos', 'fedora', 'amazon'
#   cmd1 = "yum -y install glibc.i686 glibc-devel.i686 libstdc++.i686 zlib-devel.i686 ncurses-devel.i686 libX11-devel.i686 libXrender.i686 libXrandr.i686 zip"
#   r = execute "install android depdencies" do
#     command cmd1
#   end
#   r.run_action(:run)
# end

case node[:platform]
when 'debian', 'ubuntu'
  file = '/usr/bin/zip'
  cmd = 'apt-get install -y zip'
when 'redhat', 'centos', 'fedora', 'amazon'
  file = '/usr/bin/zip'
  cmd = 'yum -y install zip'
end

execute 'install zip' do
  command cmd
  not_if {::File.exists?(file)}
end.run_action(:run)
# case node[:platform]
# when 'debian','ubuntu'
# 	file = '/usr/local/bin/aws'
# 	cmd = "apt-get install -y python-pip && pip install awscli"
# when 'redhat','centos','fedora','amazon'
# 	file = "/usr/bin/aws"
# 	cmd ="yum -y install python-pip && pip install awscli"
# end

# r = execute 'install awscli' do
# 	command cmd
# 	not_if {::File.exists?(file)}
# 	if node[:awscli][:compile_time]
# 		action :nothing
# 	end
# end

# if node[:awscli][:compile_time]
# 	r.run_action(:run)
# end

# if node[:awscli][:config_profiles]
#   config_file="/root/.aws/config"

#   r = directory ::File.dirname(config_file) do
#     recursive true
#     owner 'root'
#     group 'root'
#     mode 00700
#     not_if { ::File.exists?(::File.dirname(config_file)) }
#     if node[:awscli][:compile_time]
#       action :nothing
#     end
#   end

#   if node[:awscli][:compile_time]
#     r.run_action(:create)
#   end

#   r = template config_file do
#     mode 00600
#     owner 'root'
#     group 'root'
#     source 'config.erb'
#     not_if { ::File.exists?(config_file) }
#     if node[:awscli][:compile_time]
#       action :nothing
#     end
#   end
#   if node[:awscli][:compile_time]
#     r.run_action(:create)
#   end
# end
directory '/opt/jarsigner' do
  action :create
end
s3_file "/opt/jarsigner/tnt-jar-signer.tar.gz" do
  remote_path "tnt-jarsigner/tnt-jar-signer.tar.gz"
  bucket "tnt-build-release"
  if node[:myface][:access_key_id]
    aws_access_key_id node[:myface][:access_key_id]
    aws_secret_access_key node[:myface][:access_key_secret]
  end
  action :create
  owner "root"
  group "root"
end