exports.errorHandler = (err, req, res, next) ->
  res.send 500, err.message
