User = require("./models").User
App = require("./models").App
_ = require("lodash")

unauthorized = (res, message) ->
  res.writeHead 401
  res.end message

module.exports = (app) ->
  #   Exchange tokens:
  app.all "/oauth/token", app.oauth.grant()

  #   Authorise screen
  app.get "/oauth/authorise", ((req, res, next) ->
    user = req.session.user
    client_id = req.query.client_id
    redirect_uri = req.query.redirect_uri

    if not user? then return res.redirect "/" # redirect to login
    if not client_id? then return unauthorized res, "A client_id is required."
    if not redirect_uri? then return unauthorized res, "A redirect_uri is required."

    App.findOne { clientId: client_id }, (err, app) ->
      if err then return unauthorized res, "The app doesn't exist."
      if not _.contains app.redirectUris, redirect_uri
        return unauthorized res, "The app doesn't have this redirect uri."

      User.findOne { username: user.username }, (err, user) ->
        if err then return unauthorized res, "The cookie lies >.<"

        userAuthorization = _.find user.authorizations, (it) -> it.app is app.clientId
        if userAuthorization? then return next() # user has already authorized this app

        res.render "authorise",
          client_id: app.client_id
          redirect_uri: redirect_uri
          username: user.username
          appname: app.name
          scopes: app.scopes
  ), app.oauth.authCodeGrant((req, next) ->
    # The first param should to indicate an error
    # The second param should a bool to indicate if the user did authorise the app
    # The third param should for the user/uid (only used for passing to saveAuthCode)
    next null, true, req.session.user.username
  )

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
      req.session = user: _.omit user, "password"
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
