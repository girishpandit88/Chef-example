#
# Cookbook Name:: myface
# Recipe:: configure_jarsigner
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

if !::File.exists?('/opt/jarsigner/tnt-jar-signing.war')
	execute "extract jarsigner" do
	  cwd "/opt/jarsigner"
	  command "tar xvzf tnt-jar-signer.tar.gz"
	  only_if {::File.directory?('/opt/jarsigner')}
	end.run_action(:run)
end

bash "update_bashrc_bashprofile" do
  user "root"
  cwd "/etc/profile.d/"
  code <<-EOH
    cat android-sdk.sh >> ~/.bashrc
    cat android-sdk.sh >> ~/.bash_profile
  EOH
  only_if {::File.exists?('/etc/profile.d/android-sdk.sh')}
  if `grep -i 'android' ~/.bashrc` !=""
    action :nothing
  end
end

bash "run jarsigner" do
  cwd "/opt/jarsigner"
  user "root"
  code <<-EOH
    ln -s /usr/local/android-sdk/tools/zipalign /usr/bin/zipalign
    source ~/.bashrc
    ./run.sh 8087
  EOH
  only_if {::File.directory?('/opt/jarsigner')}
  if `ps aux|grep -v grep|grep java| awk {'print $2'}` !=""
  	action :nothing
  end
end

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
