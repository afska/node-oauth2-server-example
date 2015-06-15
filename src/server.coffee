express = require("express")

# Automatically export enviroment variables
(try require("./config/env"))?()

# Express config
app = express()
require("./config/bodyParsers.config") app
require("./config/rendering.config") app
require("./config/session.config") app
require("./config/oauthServer.config") app

# Routes
require("./routes") app
app.use app.oauth.errorHandler()

# Listen...
app.listen 3000
console.log "Listening at 3000..."
