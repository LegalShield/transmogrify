Url       = require 'url'
base64Url = require 'base64-url'
qs        = require 'querystring'

module.exports = exports = (params) ->
  unescaped = base64Url.unescape params
  unencoded = base64Url.decode unescaped
  JSON.parse unencoded
