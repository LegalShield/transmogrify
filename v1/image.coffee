im      = require('gm').subClass(imageMagick: true)
path    = require 'path'
request = require 'request'

# transform option
# null - width & height are treated as *maximum* values, aspect ratio is preserved
# ^    - width & height are treated as *minimum* values, aspect ratio is preserved
# !    - width & height are treated as *exact* values, aspect ratio is ignored
# >    - only resize if image's width || height exceeds specified geometry
# <    - only resize if image's width && height are less than the geometry specification

class Image
  contentTypeMap =
    '.gif':  'image/gif'
    '.jpeg': 'image/jpeg'
    '.jpg':  'image/jpeg'
    '.png':  'image/png'

  url     = null
  options = null

  fileExt  = -> path.extname(path.basename(url.path))
  fileName = -> "image#{fileExt()}"

  shouldResize       = -> !!(width() || height() || transform())
  shouldChangeFormat = -> format() in [ 'gif', 'jpg', 'jpeg', 'png' ]

  width     = -> if isNaN(options.width)  then options.width  else parseInt(options.width)
  height    = -> if isNaN(options.height) then options.height else parseInt(options.height)
  transform = -> options.transform
  format    = -> options.type

  constructor: (params) ->
    url     = params.url
    options = params

  contentType: -> contentTypeMap[fileExt()]

  stream: (next) ->
    img = im(request.get(url.href), fileName())
    img.on 'error', next
    img.noProfile()
    img.trim()
    img.resize(width(), height(), transform()) if shouldResize()
    img.setFormat(format()) if shouldChangeFormat()
    img.stream next

module.exports = exports = Image
