#
# Cookbook Name:: myface
# Recipe:: configure_jarsigner
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

directory "/work" do
  owner "root"
  group "root"
  mode "0000"
  action :create
  not_if {::File.directory?('/work')}
end

if !::File.directory?('/opt/jarsigner')
  directory '/opt/jarsigner' do
    owner "root"
    group "root"
    mode "0755"
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
end

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
