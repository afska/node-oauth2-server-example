deserialize = (hashedObject) ->
  try JSON.parse new Buffer(hashedObject, "base64").toString("utf8")

module.exports = (req, res, next) ->
  req.user = deserialize req.session?.passport?.user
  next()
