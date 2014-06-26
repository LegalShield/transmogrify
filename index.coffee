express = require('express')
app     = express()
morgan  = require 'morgan'
V1      = require './v1'
config  = require './config'

app.use morgan 'dev'
app.use express.static(__dirname + '/public')

app.get '/v1/transform/:params', V1.TransformController.show

app.use (err, req, res, next) ->
  console.log err
  res.send 500, err.message

server = app.listen config.port, ->
  console.log('Listening on port %d', server.address().port)
