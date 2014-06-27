env =
  protocol: 'https'
  hostname: 'images.shakelaw.com'
  port:     7070

map =
  production: Object.create(env)
  local:      Object.create(env)

map.local.protocol = 'http'
map.local.hostname = 'localhost'

module.exports = exports = map[process.env.NODE_ENV || 'local']
