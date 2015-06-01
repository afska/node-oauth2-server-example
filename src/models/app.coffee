mongoose = require("mongoose")
Schema = mongoose.Schema

OAuthAppsSchema = new Schema
  clientId:
    type: String
    unique: true
    required: true
  clientSecret:
    type: String
    required: true
  scopes:
    type: String
    required: true
  redirectUri:
    type: String
    required: true
  name:
    type: String
    required: true

OAuthAppsSchema.static "getClient", (clientId, clientSecret, cb) ->
  params = clientId: clientId
  if clientSecret != null
    params.clientSecret = clientSecret

  OAuthAppsModel.findOne params, cb

OAuthAppsSchema.static "grantTypeAllowed", (clientId, grantType, cb) ->
  if grantType is "password" or grantType is "authorization_code"
    return cb false, true
  
  cb false, false

mongoose.model "apps", OAuthAppsSchema
OAuthAppsModel = mongoose.model "apps"

module.exports = OAuthAppsModel