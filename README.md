Searching books in Kawasaki library by LINE BOT API.

## Installation
```
$ git clone https://github.com/kiyodori/line-bot.git
```

## Usage
It is easy to use Heroku for usage.

### Create application
```
$ heroku create #{application name}
```

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
