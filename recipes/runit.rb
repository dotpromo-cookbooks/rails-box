# Runit setup

include_recipe 'runit'

runit_service "runsvdir-#{node['dotpromo-rails-box']['app_name'].gsub(/\s/, '_')}" do
  run_template_name 'runsvdir-deployer'
  default_logger true
  log true
end
