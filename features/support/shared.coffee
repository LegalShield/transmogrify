require '../'

config    = require '../../config'
Data      = require './data'
selectors = require './selectors'
request   = require 'request'
http      = require 'http'
Url       = require 'url'
tmp       = require 'tmp'
fs        = require 'fs'
path      = require 'path'
qs        = require 'querystring'

urlify = (url, params, next) ->
  url = Url.parse(url)
  url.protocol ||= config.protocol
  url.hostname ||= config.hostname
  url.port     ||= config.port
  url.search   ||= "?#{qs.stringify(params)}" if Object.keys(params).length
  next null, Url.parse(Url.format(url))

downloadAndSave = (url, next) ->
  ext = path.extname(path.basename(url.pathname))
  tmp.file postfix: ext, (err, filePath) ->
    file = fs.createWriteStream filePath
    file.on 'error', next
    file.on 'close', -> next(err, file.path)
    file.on 'open', ->
      http.get url.href, (res) ->
        Data.response = res
        res.pipe(file)

transformUrl = (url, next) ->
  base64ed = new Buffer(url.href).toString('base64')
  encoded = encodeURIComponent(base64ed)
  urlify "/v1/t/#{encoded}", {}, next

exports.selectorFor = (locator, next) ->
  for regexp, value of selectors
    return next(value) if match = locator.match(new RegExp(regexp))

exports.download = (url, params, next) ->
  urlify url, params, (err, url) ->
    transformUrl url, (err, url) ->
      downloadAndSave url, (err, filePath) ->
        Data.filePath = filePath
        next err, filePath
