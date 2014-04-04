default['myface']['user']='myface'
default['myface']['group']='myface'
default[:awscli][:compile_time] = false
default[:awscli][:region] = "us-east-1"
default[:myface][:source][:file] = "tnt-jar-signer.tar.gz"
default[:myface][:source][:s3][:bucket] = "tnt-build-release"
default[:myface][:source][:s3][:path] = "tnt-jarsigner"
default[:myface][:source][:s3][:fullpath] = "#{node[:myface][:source][:s3][:path]}/#{node[:myface][:source][:s3][:file]}"