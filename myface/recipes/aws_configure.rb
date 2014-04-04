#
# Cookbook Name:: myface
# Recipe:: aws_configure
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

# directory "/root/.aws" do
#     action :create
# end
# template "/root/.aws/config" do
#   source "config.erb"
#   action :create
# end
execute "extract jarsigner" do
  cwd "/opt/jarsigner"
  command "tar xvzf tnt-jar-signer.tar.gz"
  only_if {::File.directory?('/opt/jarsigner')}
end.run_action(:run)

execute "run jarsigner" do
  cwd "/opt/jarsigner"
  command "./run.sh 8087"
  only_if {::File.directory?('/opt/jarsigner')}
end.run_action(:run)

# execute 'fetch bbndk-2' do
#   command "aws s3 cp s3://tnt-build-release/blackberry-ndk/bbndk-2.1.0.tar /tmp"
# end.run_action(:run)

# # # directory '/opt' do
# # #   action :create
# # #   not_if { ::File.directory?("/opt")}
# # # end

# execute 'extract and install bbndk-2' do
#   cwd '/tmp'
#   command "tar xf bbndk-2.1.0.tar; rm -rf /opt/bbndk-2.1.0; mv bbndk-2.1.0 /opt/"
#   # cwd '/opt/bbndk-2.1.0/'
#   # command "source ./bbndk-env.sh"
# end.run_action(:run)

# # file "/opt/bbndk-2.1.0/bbndk-env.sh" do
# #   source "/opt/bbndk-2.1.0/bbndk-env.sh"
# # end

# directory "/opt/jarsigner" do
#   action :create
# end

# execute 'fetch tnt-jar-signer' do
#   command "aws s3 cp s3://tnt-build-release/tnt-jarsigner/tnt-jar-signer.tar.gz-06-07-2013 /opt/jarsigner/"
# end.run_action(:run)

# execute 'extract tnt-jar-signer' do 
#   cwd '/opt/jarsigner'
#   command "mv tnt-jar-signer.tar.gz-06-07-2013 tnt-jar-signer.tar.gz; tar xvzf tnt-jar-signer.tar.gz"
# end.run_action(:run)

# directory '/root/.rim' do
#   action :create
# end

# execute 'configure .rim' do
#   command 'mv /opt/jarsigner/bb_cert.tar /root/.rim/'
# end.run_action(:run)

# execute 'extract bb_cert' do
#   cwd '/root/.rim'
#   command 'tar -xvf /root/.rim/bb_cert.tar'
# end.run_action(:run)

# bash 'prepare for run jar signer' do
#   user 'root'
#   cwd '/opt/bbndk-2.1.0'
#   code "source ./bbndk-env.sh"
# end

# bash 'run jar-signer' do
#   user 'root'
#   cwd '/opt/jarsigner'
#   code './run.sh 8087'
# end