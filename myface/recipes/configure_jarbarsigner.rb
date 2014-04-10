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
  s3_file "/opt/jarsigner/tnt-jar-bar-signer.tar.gz" do
    remote_path "tnt-jarsigner/tnt-jar-bar-signer.tar.gz"
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

if !::File.directory?('/opt/bbndk-2.1.0')
  s3_file "/opt/bbndk-2.1.0.tar" do
    remote_path "blackberry-ndk/bbndk-2.1.0.tar"
    bucket "tnt-build-release"
    if node[:myface][:access_key_id]
      aws_access_key_id node[:myface][:access_key_id]
      aws_secret_access_key node[:myface][:access_key_secret]
    end
    action :create
    owner "root"
    group "root"
  end
  bash "extract bbndk-2.1.0" do
    user "root"
    cwd "/opt"
    code <<-EOH
      tar xvf bbndk-2.1.0.tar
    EOH
    only_if {::File.exists?('/opt/bbndk-2.1.0.tar')}
  end
  bash "update_bashrc_bashprofile_for_bbndk" do
    user "root"
    cwd "/opt/bbndk-2.1.0/"
    code <<-EOH
      cat bbndk-env.sh >> ~/.bashrc
      cat bbndk-env.sh >> ~/.bash_profile
    EOH
    only_if {::File.exists?('/opt/bbndk-2.1.0/bbndk-env.sh')}
    if `grep -i 'bbndk' ~/.bashrc` !=""
      action :nothing
    end
  end
end

if !::File.exists?('/opt/jarsigner/run.sh')
	execute "extract jarbarsigner" do
	  cwd "/opt/jarsigner"
	  command "tar xvzf tnt-jar-bar-signer.tar.gz"
	  only_if {::File.directory?('/opt/jarsigner')}
	end.run_action(:run)
end

directory '/root/.rim' do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "configure_rim" do 
  user "root"
  code <<-EOH
    mv /opt/jarsigner/bb_cert.tar /root/.rim/
  EOH
  not_if {::File.exists?('/root/.rim/bb_cert.tar')}
end

bash "extract_bb_cert" do
  user "root"
  cwd "/root/.rim"
  code <<-EOH
    tar xvf bb_cert.tar
  EOH
  not_if {::File.exists?('/root/.rim/barsigner.db')}
end


bash "update_bashrc_bashprofile_for_android" do
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



bash "run jarbarsigner" do
  cwd "/opt/jarsigner"
  user "root"
  code <<-EOH
    ln -s /usr/local/android-sdk/tools/zipalign /usr/bin/zipalign
    ln -s /opt/bbndk-2.1.0/host/linux/x86/usr/bin/blackberry-signer /usr/bin/blackberry-signer
    QNX_TARGET="/opt/bbndk-2.1.0/target/qnx6"
    QNX_HOST="/opt/bbndk-2.1.0/host/linux/x86"
    QNX_CONFIGURATION="/etc/rim/bbndk"
    MAKEFLAGS="-I$QNX_TARGET/usr/include"
    LD_LIBRARY_PATH="$QNX_HOST/usr/lib:$LD_LIBRARY_PATH"
    PATH="$QNX_HOST/usr/bin:$QNX_CONFIGURATION/bin:$PATH"
    ./run.sh 8087
  EOH
  only_if {::File.directory?('/opt/jarsigner')}
  if `ps aux|grep -v grep|grep java| awk {'print $2'}` !=""
  	action :nothing
  end
end