User = require("../models").User
App = require("../models").App
url = require("url")
authenticate = require("./middlewares/authenticate")
_ = require("lodash")

module.exports = (app) ->
  authCodeValidate = (req, res, next, cb = ->) ->
    user = req.session.user
    client_id = req.query.client_id
    redirect_uri = req.query.redirect_uri

    if not req.user? # redirect to login
      return res.redirect "http://producteca.com/?redirectUri=#{req.url}"
    if req.query.response_type isnt "code" then unauthorized res, "The response_type must by 'code'."
    if not client_id? then return unauthorized res, "A client_id is required."
    if not redirect_uri? then return unauthorized res, "A redirect_uri is required."

    App.findOne { clientId: client_id }, (err, app) ->
      if err then return unauthorized res, "The app doesn't exist."
      if redirect_uri isnt app.redirectUri
        return unauthorized res, "The redirect_uri is invalid."

      User.findOne { username: user.username }, (err, user) ->
        if err then return unauthorized res, "The cookie lies >.<"

        userAuthorization = _.find user.authorizations, (it) -> it.app is app.clientId
        if userAuthorization? # user has already authorized this app
          req.body.allow = "yes"
          return next()

        cb user: user, app: app

  authCodeMiddleware = ->
    app.oauth.authCodeGrant (req, next) ->
      # The first param should to indicate an error
      # The second param should a bool to indicate if the user did authorise the app
      # The third param should for the user/uid (only used for passing to saveAuthCode)
      next null, req.body.allow is "yes", req.session.user.username

  #   Exchange tokens:
  app.all "/oauth/token", app.oauth.grant()

  #   Authorise screen
  app.get "/oauth/authorise", authenticate, ((req, res, next) ->
    authCodeValidate req, res, next, (viewModel) ->
      res.render "authorise", viewModel
  ), authCodeMiddleware()

  #   Handle authorise:
  app.post "/oauth/authorise", ((req, res, next) ->
    authCodeValidate req, res, next, ({user, app}) ->
      user.authorizations.push app: app.clientId, scopes: app.scopes
      user.save()
      next()
  ), authCodeMiddleware()
