module.exports = (app) ->
  #   Exchange tokens:
  app.all "/oauth/token", app.oauth.grant()

  #   Handle authorise:
  app.post "/oauth/authorise", ((req, res, next) ->
    if not req.session.userId
      return res.redirect "/session?redirect=" + req.path + "client_id=" + req.query.client_id + "&redirect_uri=" + req.query.redirect_uri
    next()
  ), app.oauth.authCodeGrant((req, next) ->
    # The first param should to indicate an error
    # The second param should a bool to indicate if the user did authorise the app
    # The third param should for the user/uid (only used for passing to saveAuthCode)
    next null, req.body.allow == "yes", req.session.userId, null
  )

  app.get "/", app.oauth.authorise(), (req, res) ->
    res.send "Secret area :O"
