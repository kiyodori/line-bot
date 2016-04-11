require 'bundler/setup'
require_relative './app'

config do
  # heroku logs setting
  $stdout.sync = true
  LOG = Logger.new(STDOUT)
  LOG.level = Logger.const_get ENV['LOG_LEVEL'] || 'DEBUG'
end

run App
