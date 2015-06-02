models = require("./models")

loginUrl = (req) ->
  "/session?redirect=" + req.path + "&client_id=" + req.query.client_id + "&redirect_uri=" + req.query.redirect_uri

module.exports = (app) ->
  #   Exchange tokens:
  app.all "/oauth/token", app.oauth.grant()

  #   Authorise screen
  app.get "/oauth/authorise", (req, res) ->
    if not req.session.userId
      return res.redirect loginUrl req

    res.render "authorise",
      client_id: req.query.client_id
      redirect_uri: req.query.redirect_uri

  #   Handle authorise:
  app.post "/oauth/authorise", ((req, res, next) ->
    if not req.session.userId
      return res.redirect loginUrl(req)

    next()
  ), app.oauth.authCodeGrant((req, next) ->
    # The first param should to indicate an error
    # The second param should a bool to indicate if the user did authorise the app
    # The third param should for the user/uid (only used for passing to saveAuthCode)
    next null, req.body.allow is "yes", req.session.userId, null
  )

  #   Login:
  app.post "/login", app.oauth.authorise(), (req, res) ->
    req.session = user: req.user
    res.send "Hi #{req.user.id}, you're now logged in. I'll give you a cookie as reward :)"

  #   Secret:
  app.get "/secret", (req, res) ->
    if not req.session.user? then return res.sendStatus 401
    res.send "boo"
