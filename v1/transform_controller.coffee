Url     = require 'url'
fs      = require 'fs'
http    = require 'http'
im      = require('gm').subClass(imageMagick: true)
path    = require 'path'
qs      = require 'querystring'
request = require 'request'
tmp     = require 'tmp'

shouldResize = (options) ->
  true in (key in ['width', 'height', 'transform'] for key in Object.keys(options))

contentTypeMap =
  '.gif':  'image/gif'
  '.jpeg': 'image/jpeg'
  '.jpg':  'image/jpeg'
  '.png':  'image/png'

knownFormats = [ 'gif', 'jpg', 'jpeg', 'png' ]

urlAndParamsFromRoute = (params, next) ->
  try
    url      = Url.parse((new Buffer(params, 'base64').toString('utf8')))
    options  = qs.parse(url.query)
    url.path = url.search = url.query = ''
    url      = Url.parse(Url.format(url))

    next null, url, options
  catch err
    next err

# transform option
# null - width & height are treated as *maximum* values, aspect ratio is preserved
# ^    - width & height are treated as *minimum* values, aspect ratio is preserved
# !    - width & height are treated as *exact* values, aspect ratio is ignored
# >    - only resize if image's width || height exceeds specified geometry
# <    - only resize if image's width && height are less than the geometry specification

exports.show = (req, res, next) ->
  urlAndParamsFromRoute req.params.params, (err, url, options) ->
    return next err if err?

    fileExt     = path.extname(path.basename(url.path))
    fileName    = "image#{fileExt}"
    contentType = contentTypeMap[fileExt]

    img = im(request.get(url.href), fileName)
    img.on 'error', next
    img.noProfile()
    img.trim()

    if shouldResize(options)
      img.resize(options.width || null, options.height || null, options.transform || null)

    if options.type in knownFormats
      img.setFormat(options.type)

    img.stream (err, stdout, stderr) ->
      res.set 'Content-Type', contentType
      stdout.pipe(res)
