express = require('express')
app     = express()
raygun  = new require('raygun').Client().init({ apiKey: 'huCbg2Ae9N6Xp3iRX5WoWg==' })

TransformController = require './transform_controller'
ErrorController     = require './error_controller'

app.get '/t/:params', TransformController.show
app.use raygun.expressHandler
app.use ErrorController.errorHandler

module.exports = exports = app
