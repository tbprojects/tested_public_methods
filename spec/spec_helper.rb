ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'rails/all'
require 'rspec/rails'
require File.expand_path('../rails_app/config/environment.rb', __FILE__)
require File.expand_path('../rails_app/spec/support/schema', __FILE__)
require File.expand_path('../../lib/tested_public_methods.rb', __FILE__)

RSpec.configure do |config|
  # some (optional) config here
end