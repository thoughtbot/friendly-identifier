TEST_ROOT = File.dirname(__FILE__)
$:.unshift(TEST_ROOT + '/../lib')

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_record/fixtures'
require 'active_support'
require File.join(TEST_ROOT, '/../init')

# Load database schema
config = YAML::load(IO.read(File.join(TEST_ROOT, 'database.yml')))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'plugin_test'])
schema = File.join(TEST_ROOT, 'schema.rb')
load schema if File.exists?(schema)

# Create a logger
ActiveRecord::Base.logger = Logger.new(File.join(TEST_ROOT, 'debug.log'))

# Test options
class Test::Unit::TestCase #:nodoc:
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
