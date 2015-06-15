models = require("../models")

module.exports = (app) =>
  app.oauth = require("oauth2-server")
    model: models.oauth
    grants: ["password", "authorization_code"]
    debug: true
    accessTokenLifetime: 2678400 # number of seconds || null (never expires)
