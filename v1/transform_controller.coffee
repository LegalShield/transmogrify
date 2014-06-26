Url     = require 'url'
http    = require 'http'
qs      = require 'querystring'
fs      = require 'fs'
path    = require 'path'
im      = require('gm').subClass(imageMagick: true)
tmp     = require 'tmp'

urlAndParamsFromRoute = (params, next) ->
  try
    url      = Url.parse((new Buffer(params, 'base64').toString('utf8')))
    options  = qs.parse(url.query)
    url.path = url.search = url.query = ''
    url      = Url.parse(Url.format(url))

    next null, url, options
  catch err
    next err

downloadFileFromUrl = (url, next) ->
  ext = path.extname(path.basename(url.path))
  tmp.file postfix: ext, (err, path, fd) ->
    file = fs.createWriteStream path
    file.on 'error', next
    file.on 'close', ->
      next(err, file.path)
    file.on 'open', ->
      http.get url.href, (res) ->
        res.pipe(file)

convertFile = (path, options, next) ->
  im(path).identify (err, features) ->
    stream = im(path)
    if options.width? || options.height? || options.option?
      stream.resize(options.width || null, options.height || null, options.option || null)
    stream.noProfile()
    stream.trim()
    stream.toBuffer(next)

exports.show = (req, res, next) ->
  urlAndParamsFromRoute req.params.params, (err, url, options) ->
    return next err if err?
    downloadFileFromUrl url, (err, path) ->
      return next err if err?
      convertFile path, options, (err, buffer) ->
        return next err if err?
        res.header 'Content-type', 'image/png'
        res.end buffer, 'binary'
