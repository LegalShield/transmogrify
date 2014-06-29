Url     = require 'url'
qs      = require 'querystring'

module.exports = exports = (params) ->
  url      = Url.parse((new Buffer(params, 'base64').toString('utf8')))
  options  = qs.parse(url.query)
  url.path = url.search = url.query = ''
  url      = Url.parse(Url.format(url))
  { url: url, options: options }
