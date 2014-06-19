describe 'dotpromo-rails-box::configs' do
  let(:chef_instance) do
    ChefSpec::Runner.new do |node|
      node.automatic['memory']['total'] = '1024Mb'
      node.set['dotpromo-rails-box']['app_name'] = 'test'
      node.set['dotpromo-rails-box']['app_dir'] = '/srv/app/test_app'
    end
  end
  let(:chef_run) do
    chef_instance.converge(described_recipe)
  end

  before :each do
    stub_command('which sudo').and_return('/usr/bin/sudo')
    stub_command("bash -c \"source /home/deployer/.rvm/scripts/rvm && type rvm | cat | head -1 | grep -q '^rvm is a function$'\"")
    stub_command('which nginx').and_return('/usr/sbin/nginx')
  end

  it 'should create database config file' do
    expect(chef_run).to render_file('/srv/app/test_app/shared/config/database.yml')
  end
end
