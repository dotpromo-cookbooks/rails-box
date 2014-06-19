template "#{node['dotpromo-rails-box']['app_dir']}/shared/config/database.yml" do
  source 'database.yml.erb'
  mode '0644'
  owner 'deployer'
  action :create_if_missing
end
