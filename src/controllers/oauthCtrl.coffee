User = require("../models").User
App = require("../models").App
_ = require("lodash")

module.exports = (app) ->
  authCodeMiddleware = (allow) ->
    app.oauth.authCodeGrant (req, next) ->
      allow = allow || req.body.allow is "yes"
      # The first param should to indicate an error
      # The second param should a bool to indicate if the user did authorise the app
      # The third param should for the user/uid (only used for passing to saveAuthCode)
      next null, allow, req.session.user.username

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
      if redirect_uri isnt app.redirectUri
        return unauthorized res, "The redirect_uri is invalid."

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
  ), authCodeMiddleware true

  #   Handle authorise:
  app.post "/oauth/authorise", ((req, res, next) ->
    if not req.session.user? then return res.redirect "/"
    next()
  ), authCodeMiddleware
