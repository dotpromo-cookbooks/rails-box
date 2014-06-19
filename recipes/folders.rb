# Folders setup

# Create application directories

def create_folder(sub)
  directory ::File.join(node['dotpromo-rails-box']['app_dir'], sub) do
    owner 'deployer'
    group 'deployer'
    mode '0755'
    recursive true
  end
end

directory node['dotpromo-rails-box']['app_dir'] do
  owner 'deployer'
  group 'deployer'
  mode '0755'
  recursive true
end

%w(shared shared/config shared/log).each do |sub|
  create_folder(sub)
end

if node['dotpromo-rails-box']['use_runit']
  create_folder('runit')
  %w(runit/available runit/enabled).each do |sub|
    create_folder(sub)
  end
end
