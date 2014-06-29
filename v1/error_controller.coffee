exports.errorHandler = (err, req, res, next) ->
  console.log err.message
  console.log err.stack
  res.send 500, err.message
