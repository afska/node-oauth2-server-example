User = require("./models").User
App = require("./models").App

module.exports = (app) ->
  #   Exchange tokens:
  app.all "/oauth/token", app.oauth.grant()

  #   Authorise screen
  app.get "/oauth/authorise", (req, res) ->
    if not req.session.user? then return res.redirect "/"

    res.render "authorise",
      client_id: req.query.client_id
      redirect_uri: req.query.redirect_uri
      name: req.session.user.username

  #   Handle authorise:
  app.post "/oauth/authorise", ((req, res, next) ->
    if not req.session.user? then return res.redirect "/"
    next()
  ), app.oauth.authCodeGrant((req, next) ->
    # The first param should to indicate an error
    # The second param should a bool to indicate if the user did authorise the app
    # The third param should for the user/uid (only used for passing to saveAuthCode)
    next null, req.body.allow is "yes", req.session.user.username
  )

  #   Login and logout:
  app.post "/login", app.oauth.authorise(), (req, res) ->
    User.findOne { username: req.user.id }, (err, user) ->
      req.session = user: user
      res.send "Hi #{req.session.user.username}, you're now logged in. I'll give you a cookie :)"

  app.post "/logout", (req, res) ->
    req.session = null
    res.send "The cookie has been destroyed."

  #   Public:
  app.get "/", (req, res) -> res.send "Home. Please login!"

  #   Secret:
  app.get "/secret", (req, res) ->
    if not req.session.user? then return res.sendStatus 401
    res.send "Hi #{req.session.user.username}! This is a secret content."
