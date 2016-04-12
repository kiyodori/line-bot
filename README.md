Searching books in Kawasaki library by LINE BOT API.

## Installation
```
$ git clone https://github.com/kiyodori/line-bot.git
```

## Usage
It is easy to use Heroku for usage.

### Create Heroku application
```
$ heroku create #{application name}
```

### Install Fixie
[Fixie](https://elements.heroku.com/addons/fixie) provides static IP addresses for outbound requests, so you can register Server IP Whitelist on LINE developers.

```
$ heroku addons:create fixie:tricycle
```

### Register LINE BOT API
You can register LINE BOT API on LINE developers.

#### Callback URL
Callback URL example.
`https://#{Heroku URL}:443/linebot/callback`

#### Server IP Whitelist
You can register Server IP Whitelist by Fixie IP addresses.

### Set Heroku config

```
$ heroku config:set LINE_CHANNEL_ID=#{Channel ID}
$ heroku config:set LINE_CHANNEL_SECRET=#{Channel secret}
$ heroku config:set LINE_CHANNEL_MID=#{Channel MID}
$ heroku config
```

### Push to Heroku server

```
$ git push heroku master
```
