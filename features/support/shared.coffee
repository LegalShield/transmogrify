process.env.NODE_ENV = 'test'

port    = 7707
express = require 'express'
request = require 'request'
Url     = require 'url'
qs      = require 'querystring'
im      = require('gm').subClass(imageMagick: true)

asset = express()
asset.use require('morgan')('dev')
asset.set 'port', port
asset.use express.static __dirname + '/fixtures'
asset.listen asset.get('port'), -> console.log  asset.get('port') + ' - Assets'

app = express()
app.use require('morgan')('dev')
app.set 'port', port + 1
app.use '/v1', require '../../v1'
app.listen app.get('port'), -> console.log app.get('port') + ' - App'

assetUrl = (url, params, next) ->
  try
    url = Url.parse(url)
    url.protocol = 'http'
    url.hostname = 'localhost'
    url.port     = port
    url.search   = "?#{qs.stringify(params)}" if Object.keys(params).length
  catch err
    return next err
  next null, Url.parse(Url.format(url))

transformUrl = (url, next) ->
  try
    base64ed = new Buffer(url.href).toString('base64')
    encoded = encodeURIComponent(base64ed)
    url = Url.parse("/v1/t/#{encoded}")
    url.protocol = 'http'
    url.hostname = 'localhost'
    url.port     = port + 1
  catch err
    return next err
  next null, Url.parse(Url.format(url))

download = (url, next) ->
  stream = request.get url.href, (err, response) ->
    exports.response = response
  im(stream).identify next

exports.download = (url, params, next) ->
  assetUrl url, params, (err, url) ->
    return next(err) if err?
    transformUrl url, (err, url) ->
      return next(err) if err?
      download url, (err, info) ->
        return next(err) if err?
        exports.info = info
        next err, info
