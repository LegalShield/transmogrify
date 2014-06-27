express = require('express')
app     = express()

TransformController = require './transform_controller'
ErrorController     = require './error_controller'

app.get '/t/:params', TransformController.show
app.use ErrorController.errorHandler

module.exports = exports = app
