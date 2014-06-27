process.env.NODE_ENV = 'test'

port    = 7707
express = require 'express'
request = require 'request'
http    = require 'http'
Url     = require 'url'
tmp     = require 'tmp'
fs      = require 'fs'
path    = require 'path'
qs      = require 'querystring'

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

downloadAndSave = (url, next) ->
  ext = path.extname(path.basename(url.pathname))
  tmp.file postfix: ext, (err, filePath) ->
    return next(err) if err?
    file = fs.createWriteStream filePath
    file.on 'error', next
    file.on 'close', -> next(err, file.path)
    file.on 'open', ->
      http.get url.href, (res) ->
        exports.data.response = res
        res.pipe(file)

exports.data = {}

exports.download = (url, params, next) ->
  assetUrl url, params, (err, url) ->
    return next(err) if err?
    transformUrl url, (err, url) ->
      return next(err) if err?
      downloadAndSave url, (err, filePath) ->
        return next(err) if err?
        exports.data.filePath = filePath
        next err, filePath
