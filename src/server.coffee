express = require("express")
bodyParser = require("body-parser")
oauthServer = require("oauth2-server")
models = require("./models")

# Express config
app = express()
#   body parsers
app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

#   rendering engine
app.engine "html", require("ejs").renderFile
app.use express.static "#{__dirname}/../views"
app.set "view engine", "html"

#   session
signature = "asdasdcookies signatureasdasd"
app.use require("cookie-parser") signature
app.use require("cookie-session")
  key: "oauth-server"
  secret: signature

# OAuth server
app.oauth = oauthServer
  model: models.oauth
  grants: ["password", "authorization_code"]
  debug: true
  accessTokenLifetime: 2678400 # number of seconds || null (never expires)

require("./routes") app

app.use app.oauth.errorHandler()

# Listen...
app.listen 3000
console.log "Listening at 3000..."

# This is an example app called Lepocamon, and provides an API that
# other apps can use with the OAuth "authorization_code" grant flow.
# The original Lepocamon users use the "password" grant flow for the login.
