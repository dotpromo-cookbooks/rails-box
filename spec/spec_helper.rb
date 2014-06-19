require 'chefspec'
ChefSpec::Coverage.start!
require_relative 'support/enable_runit_service'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '12.04'
end
