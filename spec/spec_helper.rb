ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../app'
require 'pry'
require "vcr"
require "minitest-vcr"
require "webmock"

include Rack::Test::Methods

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

MinitestVcr::Spec.configure!
def app
  Sinatra::Application
end

