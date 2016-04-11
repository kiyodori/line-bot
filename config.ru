require 'bundler/setup'
require_relative './app'

# print heroku logs
$stdout.sync = true

run App
