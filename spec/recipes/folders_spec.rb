describe 'dotpromo-rails-box::folders' do
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

  it 'creates an app folder structure' do
    root = '/srv/app/test_app'
    %W(#{root} #{root}/shared #{root}/shared/config #{root}/shared/log).each do |folder|
      expect(chef_run).to create_directory(folder)
    end
  end

  describe 'with runit' do
    it 'creates a runit folder structure' do
      root = '/srv/app/test_app'
      %W(#{root} #{root}/runit #{root}/runit/enabled #{root}/runit/available).each do |folder|
        expect(chef_run).to create_directory(folder).with(
          user: 'deployer',
          group: 'deployer'
        )
      end
    end
  end

  describe 'without runit' do
    let(:chef_instance) do
      ChefSpec::Runner.new do |node|
        node.automatic['memory']['total'] = '1024Mb'
        node.set['dotpromo-rails-box']['app_name'] = 'test'
        node.set['dotpromo-rails-box']['app_dir'] = '/srv/app/test_app'
        node.set['dotpromo-rails-box']['use_runit'] = false
      end
    end
    it 'not creates a runit folder structure' do
      root = '/srv/app/test_app'
      %W(#{root}/runit #{root}/runit/enabled #{root}/runit/available).each do |folder|
        expect(chef_run).to_not create_directory(folder).with(
          user: 'deployer',
          group: 'deployer'
        )
      end
    end

  end

end
