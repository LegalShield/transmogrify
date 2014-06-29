express = require('express')
app     = express()
morgan  = require 'morgan'

app.use(require('morgan')('dev'))

app.use '/v1', require './v1'
app.use '/',   require './app'

port = process.env.PORT || 7070
server = app.listen port, ->
  console.log('Listening on port %d', server.address().port)
