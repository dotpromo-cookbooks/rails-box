require 'minitest/spec'
require 'minitest-chef-handler'
describe_recipe 'dotpromo-rails-box::folders' do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe 'folders' do
    it 'creates an app folder structure' do
      root = node['dotpromo-rails-box']['app_dir']
      %W(#{root} #{root}/shared #{root}/shared/config #{root}/shared/log).each do |folder|
        directory(folder).must_exist.with(:owner, 'deployer')
      end
    end
    it 'creates a runit folder structure' do
      return unless node['dotpromo-rails-box']['use_runit']
      root = node['dotpromo-rails-box']['app_dir']
      %W(#{root} #{root}/runit #{root}/runit/enabled #{root}/runit/available).each do |folder|
        directory(folder).must_exist.with(:owner, 'deployer')
      end
    end
    it 'creates nginx config file' do
      file("#{node['nginx']['dir']}/sites-available/#{node['dotpromo-rails-box']['app_name'].gsub(/\s/, '_')}.conf").must_exist
      link("#{node['nginx']['dir']}/sites-enabled/#{node['dotpromo-rails-box']['app_name'].gsub(/\s/, '_')}.conf").must_exist.with(
          :link_type, :symbolic).and(:to, "#{node['nginx']['dir']}/sites-available/#{node['dotpromo-rails-box']['app_name'].gsub(/\s/, '_')}.conf")
    end
    it 'creates proper root sv runit folder' do
      return unless node['dotpromo-rails-box']['use_runit']
      directory("#{node['runit']['sv_dir']}/runsvdir-#{node['dotpromo-rails-box']['app_name'].gsub(/\s/, '_')}").must_exist
    end

    it 'includes proper upstream string in nginx config' do
      str = "server unix:#{node['dotpromo-rails-box']['app_dir']}/shared/tmp/sockets/#{node['dotpromo-rails-box']['sock_file']} fail_timeout=0"
      file("#{node['nginx']['dir']}/sites-available/#{node['dotpromo-rails-box']['app_name'].gsub(/\s/, '_')}.conf").must_include(str)
    end
  end
end
