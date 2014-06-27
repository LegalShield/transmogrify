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

app = express()
#app.use require('morgan')('dev')
app.use express.static __dirname + '/fixtures'
app.use '/v1', require '../../v1'
app.listen port, -> console.log 'Listening on port ' + port

urlify = (url, params, next) ->
  url = Url.parse(url)
  url.protocol ||= 'http'
  url.hostname ||= 'localhost'
  url.port     ||= port
  url.search   ||= "?#{qs.stringify(params)}" if Object.keys(params).length
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

transformUrl = (url, next) ->
  base64ed = new Buffer(url.href).toString('base64')
  encoded = encodeURIComponent(base64ed)
  urlify "/v1/t/#{encoded}", {}, next

exports.download = (url, params, next) ->
  urlify url, params, (err, url) ->
    return next(err) if err?
    transformUrl url, (err, url) ->
      return next(err) if err?
      downloadAndSave url, (err, filePath) ->
        return next(err) if err?
        exports.data.filePath = filePath
        next err, filePath

exports.data = {}
