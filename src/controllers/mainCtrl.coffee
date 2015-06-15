User = require("../models").User
_ = require("lodash")
authenticate = require("./middlewares/authenticate")

module.exports = (app) ->
  #   Public:
  app.get "/", (req, res) ->
    res.send "Home. Please login!"

  #   Secret:
  app.get "/secret", authenticate, (req, res) ->
    if not req.user? then return unauthorized res, "You have to login in Producteca!"
    res.send "Hi #{req.user.profile.firstName} #{req.user.profile.lastName}! This is a secret content."
