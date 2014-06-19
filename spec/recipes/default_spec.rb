describe 'dotpromo-rails-box::default' do
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

  %w(dotpromo-ruby-box dotpromo-postgresql-box database::postgresql).each do |k|
    it "includes the `#{k}` recipe" do
      expect(chef_run).to include_recipe(k)
    end
  end

  %w(folders nginx database configs).each do |k|
    it "includes the `dotpromo-rails-box::#{k}` recipe" do
      expect(chef_run).to include_recipe("dotpromo-rails-box::#{k}")
    end
  end

  describe 'with redis' do
    %w(redisio::install redisio::enable).each do |k|
      it "includes the `#{k}` recipe" do
        expect(chef_run).to include_recipe(k)
      end
    end
  end

  describe 'without redis' do
    let(:chef_instance) do
      ChefSpec::Runner.new do |node|
        node.automatic['memory']['total'] = '1024Mb'
        node.set['dotpromo-rails-box']['app_name'] = 'test'
        node.set['dotpromo-rails-box']['app_dir'] = '/srv/app/test_app'
        node.set['dotpromo-rails-box']['install_redis'] = false
      end
    end
    %w(redisio::install redisio::enable).each do |k|
      it "not includes the `#{k}` recipe" do
        expect(chef_run).to_not include_recipe(k)
      end
    end
  end

  describe 'with runit' do
    it 'includes the `runit` recipe' do
      expect(chef_run).to include_recipe('runit')
    end
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
    it 'not includes the `runit` recipe' do
      expect(chef_run).to_not include_recipe('runit')
    end

  end

  describe 'with java' do
    let(:chef_instance) do
      ChefSpec::Runner.new do |node|
        node.automatic['memory']['total'] = '1024Mb'
        node.set['dotpromo-rails-box']['app_name'] = 'test'
        node.set['dotpromo-rails-box']['app_dir'] = '/srv/app/test_app'
        node.set['dotpromo-rails-box']['install_java'] = true
      end
    end
    it 'includes the `java` recipe' do
      expect(chef_run).to include_recipe('java')
    end
  end

  describe 'without java' do
    it 'not includes the `java` recipe' do
      expect(chef_run).to_not include_recipe('java')
    end
  end

end
