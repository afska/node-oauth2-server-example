User = require("../models").User
_ = require("lodash")

module.exports = (app) ->
  #   Login and logout:
  app.post "/login", app.oauth.authorise(), (req, res) ->
    User.findOne { username: req.user.id }, (err, user) ->
      req.session = user: _.pick user, "username"
      res.send "Hi #{req.session.user.username}, you're now logged in. I'll give you a cookie :)"

  app.post "/logout", (req, res) ->
    req.session = null
    res.send "The cookie has been destroyed."

  #   Public:
  app.get "/", (req, res) -> res.send "Home. Please login!"

  #   Secret:
  app.get "/secret", (req, res) ->
    if not req.session.user? then return unauthorized res, "Unauthorized!!! -.-"
    res.send "Hi #{req.session.user.username}! This is a secret content."
