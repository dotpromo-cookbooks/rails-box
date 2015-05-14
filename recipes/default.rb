#
# Cookbook Name:: dotpromo-rails-box
# Recipe:: default
#
# Copyright 2014, .PROMO Inc
#
include_recipe 'ntp::default'
include_recipe 'simple_iptables'

# Default iptables rules
simple_iptables_policy "INPUT" do
  policy "DROP"
end

simple_iptables_rule "established" do
  chain "INPUT"
  rule "-m conntrack --ctstate ESTABLISHED,RELATED"
  jump "ACCEPT"
  weight 1
  ip_version :ipv4
end

simple_iptables_rule "icmp" do
  chain "INPUT"
  rule "--proto icmp"
  jump "ACCEPT"
  weight 2
  ip_version :ipv4
end

simple_iptables_rule "loopback" do
  chain "INPUT"
  rule "--in-interface lo"
  jump "ACCEPT"
  weight 3
  ip_version :ipv4
end

simple_iptables_rule "ssh" do
  chain "INPUT"
  rule "--proto tcp --dport 22 -m conntrack --ctstate NEW"
  jump "ACCEPT"
  weight 70
  ip_version :ipv4
end

simple_iptables_rule "reject" do
  chain "INPUT"
  rule ""
  jump "REJECT --reject-with icmp-host-prohibited"
  weight 100
  ip_version :ipv4
end

simple_iptables_rule "reject" do
  direction "FORWARD"
  chain "FORWARD"
  rule ""
  jump "REJECT --reject-with icmp-host-prohibited"
  weight 100
  ip_version :ipv4
end

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
