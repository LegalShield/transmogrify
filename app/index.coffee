express = require 'express'
app = express()
app.use express.static(__dirname + '/public')
app.use express.static(__dirname + '/bower_components/bootstrap/dist')
app.use express.static(__dirname + '/bower_components/jquery/dist')
app.use express.static(__dirname + '/bower_components/jquery.serializeJSON')
module.exports = exports = app
