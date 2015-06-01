mongoose = require("mongoose")

Schema = mongoose.Schema
AccessTokensSchema = new Schema
  accessToken:
    type: String
    required: true
    unique: true
  clientId: String
  userId:
    type: String
    required: true
  expires: Date

# Retrieves an access token
module.exports.getAccessToken = (bearerToken, cb) ->
  AccessTokensModel.findOne { accessToken: bearerToken }, cb

# Creates an access token
module.exports.saveAccessToken = (token, clientId, expires, userId, cb) ->
  fields =
    clientId: clientId
    userId: userId
    expires: expires

  AccessTokensModel.update { accessToken: token }, fields, { upsert: true }, (err) ->
    if err then console.error err
    cb err

mongoose.model "accessTokens", AccessTokensSchema
AccessTokensModel = mongoose.model "accessTokens"
