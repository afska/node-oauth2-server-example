mongoose = require("mongoose")
Schema = mongoose.Schema

AppsSchema = new Schema
  clientId:
    type: String
    unique: true
    required: true
  clientSecret:
    type: String
    required: true
  name:
    type: String
    required: true
  scopes:
    type: String
    required: true
  redirectUri:
    type: String
    required: true

# Retrieves an App from the DB
AppsSchema.static "getClient", (clientId, clientSecret, cb) ->
  params = clientId: clientId
  if clientSecret isnt null
    params.clientSecret = clientSecret

  AppsModel.findOne params, cb

# Returns if an App supports a specific grant type
AppsSchema.static "grantTypeAllowed", (clientId, grantType, cb) ->
  if grantType is "password" or grantType is "authorization_code"
    return cb false, true

  cb false, false

mongoose.model "apps", AppsSchema
AppsModel = mongoose.model "apps"

module.exports = AppsModel
