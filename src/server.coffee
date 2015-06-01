express = require("express")
bodyParser = require("body-parser")
oauthServer = require("oauth2-server")

# Express & Body parser
app = express()
app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

# OAuth server
app.oauth = oauthServer
  model: {}
  grants: ["password", "authorization_code"]
  debug: true
  accessTokenLifetime: 2678400 # number of seconds || null (never expires)
app.use app.oauth.errorHandler()

# Routes
app.all "/oauth/token", app.oauth.grant()
app.get "/", app.oauth.authorise(), (req, res) ->
  res.send 'Secret area :O'

# Listen...
app.listen 3000
console.log "Listening at 3000..."

# This is an example app called Lepocamon, and provides an API that
# other apps can use with the OAuth "authorization_code" grant flow.
# The original Lepocamon users use the "password" grant flow for the login.
