Url     = require 'url'
fs      = require 'fs'
http    = require 'http'
im      = require('gm').subClass(imageMagick: true)
path    = require 'path'
qs      = require 'querystring'
request = require 'request'
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

#downloadFileFromUrl = (url, next) ->
  #ext = path.extname(path.basename(url.path))
  #tmp.file postfix: ext, (err, path, fd) ->
    #file = fs.createWriteStream path
    #file.on 'error', next
    #file.on 'close', ->
      #next(err, file.path)
    #file.on 'open', ->
      #http.get url.href, (res) ->
        #res.pipe(file)

# transform option
# null - width & height are treated as *maximum* values, aspect ratio is preserved
# ^    - width & height are treated as *minimum* values, aspect ratio is preserved
# !    - width & height are treated as *exact* values, aspect ratio is ignored
# >    - only resize if image's width || height exceeds specified geometry
# <    - only resize if image's width && height are less than the geometry specification

#convertFile = (path, options, next) ->
  #im(path).identify (err, features) ->
    #stream = im(path)
    #stream = im(buffer)
    #if options.width? || options.height? || options.transform?
      #stream.resize(options.width || null, options.height || null, options.transform || null)
    #stream.noProfile()
    #stream.trim()
    #stream.toBuffer(next)

convertBuffer = (buffer, options, next) ->
  im(buffer).identify (err, features) ->
    console.log err
    stream = im(buffer)
    if options.width? || options.height? || options.transform?
      stream.resize(options.width || null, options.height || null, options.transform || null)
    stream.noProfile()
    stream.trim()
    stream.toBuffer(next)

exports.show = (req, res, next) ->
  urlAndParamsFromRoute req.params.params, (err, url, options) ->
    return next err if err?

    fileExt     = path.extname(path.basename(url.path))
    fileName    = "image#{fileExt}"
    contentType = "image/#{fileExt.slice(1)}"

    im(request.get(url.href), fileName)
      .resize(options.width || null, options.height || null, options.transform || null)
      .noProfile()
      .trim()
      .stream (err, stdout, stderr) ->
        res.set 'Content-Type', contentType
        stdout.pipe(res)
