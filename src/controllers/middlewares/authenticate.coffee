deserialize = (hashedObject) ->
  try JSON.parse new Buffer(hashedObject, "base64").toString("utf8")

module.exports =
    authenticated = (req, res, next) ->
      req.user = deserialize req.session?.passport?.user

      if req.user? then next()
      else unauthorized res, "Unauthorized!!! -.-"
