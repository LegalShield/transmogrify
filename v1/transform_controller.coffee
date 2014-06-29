ParamsParser = require './params_parser'
Image        = require './image'

exports.show = (req, res, next) ->
  { url, options } = ParamsParser(req.params.params)
  image = new Image(url, options)
  res.set 'Content-Type', image.contentType()
  image.stream (err, stdout, stderr) -> stdout.pipe(res)
