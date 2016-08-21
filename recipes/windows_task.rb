#
# Cookbook Name:: serverspec_custom_type
# Recipe:: windows_task
#
# Copyright 2016, Chris Sullivan
#
# All rights reserved - Do Not Redistribute
#

directory 'c:\serverspec\custom' do
  recursive true
  action :create
end

cookbook_file 'c:\serverspec\custom\schedule_task.rb' do
  source 'schedule_task.rb'
  action :create
end
