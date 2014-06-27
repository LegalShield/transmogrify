config  = require './config'
express = require('express')
app     = express()
morgan  = require 'morgan'

app.use(require('morgan')('dev'))
app.use express.static(__dirname + '/public')

app.use '/v1', require './v1'

server = app.listen config.port, ->
  console.log('Listening on port %d', server.address().port)
