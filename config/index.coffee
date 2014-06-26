env =
  protocol: 'https'
  hostname: 'images.shakelaw.com'
  port:     '8080'

map =
  production: Object.create(env)
  local:      Object.create(env)
  test:       Object.create(env)

map.local.protocol = 'http'
map.local.hostname = 'localhost'

map.test.protocol = 'http'
map.test.hostname = 'localhost'
map.test.port     = 7384

module.exports = exports = map[process.env.NODE_ENV || 'local']
