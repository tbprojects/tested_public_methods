ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'rails/all'
require File.expand_path('../../config/environment.rb', __FILE__)
require 'support/schema'

RSpec.configure do |config|
  # some (optional) config here
end