require 'rspec'
require 'fake_web'
require 'activeresource_headers'
require 'active_resource'
require 'active_support/inflector'

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.after(:each) do
    FakeWeb.clean_registry
  end
end

REMOTE_HOST = "http://127.0.0.1:3000"

def unset_const(const_name)
  const_name = const_name.to_sym
  const_owner = Module.constants.select { |c| c.to_s.constantize.constants(false).include?(const_name) rescue false }.first.to_s.constantize
  !const_owner.send(:remove_const, const_name) rescue true
end
