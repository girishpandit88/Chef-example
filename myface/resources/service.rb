#
# Cookbook Name:: myface
# Resource:: service
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

actions :start, :stop

default_action :start

attribute :process_name	, :kind_of => String
# attribute :

def initialize(*args)
	super
	@action = :start
end

attr_accessor :exists