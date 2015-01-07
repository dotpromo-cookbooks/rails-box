#
# Cookbook Name:: dotpromo-rails-box
# Recipe:: default
#
# Copyright 2014, .PROMO Inc
#
include_recipe 'ntp::default'
%w(dotpromo-ruby-box dotpromo-postgresql-box database::postgresql).each do |r|
  include_recipe r
end
%w(folders nginx database configs).each do |k|
  include_recipe "dotpromo-rails-box::#{k}"
end
if node['dotpromo-rails-box']['install_redis']
  include_recipe 'redisio'
  include_recipe 'redisio::enable'
end

include_recipe 'dotpromo-rails-box::runit' if node['dotpromo-rails-box']['use_runit']
if node['dotpromo-rails-box']['install_java']
  include_recipe 'dotpromo-rails-box::java'
end
