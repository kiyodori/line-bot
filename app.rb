require 'sinatra/base'
require 'json'
require 'rest-client'
require_relative 'model/klibrary'

class App < Sinatra::Base
  post '/linebot/callback' do
    logger.info "---------check----------"
    # klibrary = Klibrary.new(msg['content']['text'])
    # search = klibrary.search
    params = JSON.parse(request.body.read)
    params['result'].each do |msg|
      logger.info "#{msg['content']['text']}"
      content = {
        contentType: 1,
        toType: 1,
        text: "てすと"
      }
      request_content = {
        to: [msg['content']['from']],
        toChannel: 1383378250, # Fixed  value
        eventType: "138311608800106203", # Fixed value
        content: content
      }

      endpoint_uri = 'https://trialbot-api.line.me/v1/events'
      content_json = request_content.to_json

      RestClient.proxy = ENV['FIXIE_URL'] if ENV['FIXIE_URL']
      RestClient.post(endpoint_uri, content_json, {
        'Content-Type' => 'application/json; charset=UTF-8',
        'X-Line-ChannelID' => ENV["LINE_CHANNEL_ID"],
        'X-Line-ChannelSecret' => ENV["LINE_CHANNEL_SECRET"],
        'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"],
      })
    end

    "OK"
  end
end
