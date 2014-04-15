#
# Cookbook Name:: myface
# Provider:: service
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

# require 'chef/resource'

def whyrun_supported?
  true
end

action :start do 
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource} already exists - nothing to do"
	else
		converge_by("Start #{ @new_resource}") do
			start_jarsigner_service(@current_resource.process_name)
		end
	end
end

action :stop do
	if @current_resource.exists
		converge_by("Stopping #{@new_resource}") do
			stop_jarsigner_service(@current_resource.process_name)
		end
	else
		Chef::Log.info "#{ @current_resource} doesn't exist - cannot stop"
	end
end

def load_current_resource
	@current_resource = Chef::Resource::MyfaceService.new(@new_resource.name)
	# @current_resource.name(@new_resource.name)
	@current_resource.process_name(@new_resource.process_name)
	if service_exists?
		@current_resource.exists = true
	end
end


def start_jarsigner_service(name)
	Chef::Log.info "Inside start method"
	bash "run jarbarsigner" do
		cwd "/opt/jarsigner"
	  	user "root"
		code <<-EOH
			~/.bash_rc
			./run.sh 8087
		EOH
		 only_if {::File.directory?('/opt/jarsigner')}
	end
end

def stop_jarsigner_service(name)
	Chef::Log.info "Inside stop method"
	result=`ps -ef|grep -v grep|grep java| awk {'print $2'}`
	Chef::Log.info "Killing jetty process with pid: #{result}"
	`kill -9 #{result}`
end


def service_exists?
	Chef::Log.info "Inside service_exists method"
	if `ps -ef|grep -v grep|grep java| awk {'print $2'}` !=""
		return true
	else
		return false
	end
end