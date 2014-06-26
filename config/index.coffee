env =
  protocol: 'https'
  hostname: 'images.shakelaw.com'
  port:     7070

map =
  production: Object.create(env)
  local:      Object.create(env)
  test:       Object.create(env)

map.local.protocol = 'http'
map.local.hostname = 'localhost'

map.test.protocol = 'http'
map.test.hostname = 'localhost'
map.test.port     = 7707

module.exports = exports = map[process.env.NODE_ENV || 'local']
