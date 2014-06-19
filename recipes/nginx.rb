# NGINX Setup

include_recipe 'nginx::repo'
include_recipe 'nginx'
include_recipe 'simple_iptables'

template "#{node['nginx']['dir']}/sites-available/#{node['dotpromo-rails-box']['app_name']}.conf" do
  source 'nginx.conf.erb'
  mode '0644'
  action :create_if_missing
end

node.set['nginx']['default_site_enabled'] = false

nginx_site "#{node['dotpromo-rails-box']['app_name']}.conf"

# Allow HTTP
simple_iptables_rule 'http' do
  rule ['--proto tcp --dport 80',
        '--proto tcp --dport 443'
       ]
  jump 'ACCEPT'
end
