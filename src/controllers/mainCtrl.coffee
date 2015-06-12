User = require("../models").User
_ = require("lodash")

module.exports = (app) ->
  #   Public:
  app.get "/", (req, res) -> res.send "Home. Please login!"

  #   Secret:
  app.get "/secret", (req, res) ->
    if not req.session.user? then return unauthorized res, "Unauthorized!!! -.-"
    res.send "Hi #{req.session.user.username}! This is a secret content."
