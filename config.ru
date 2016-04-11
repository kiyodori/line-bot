require 'bundler/setup'
require_relative './app'

# heroku logs setting
$stdout.sync = true

run App
