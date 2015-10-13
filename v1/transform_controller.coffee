ParamsParser = require './params_parser'
Image        = require './image'

exports.show = (req, res, next) ->
  params = ParamsParser(req.params.params)
  image = new Image(params)
  res.set 'Content-Type', image.contentType()
  image.stream (err, stdout, stderr) ->
    return next(err) if err?
    stdout.pipe(res)
