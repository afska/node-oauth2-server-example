mongoose = require("mongoose")

Schema = mongoose.Schema
AuthCodesSchema = new Schema
  authCode:
    type: String
    required: true
    unique: true
  clientId: String
  userId:
    type: String
    required: true
  expires: Date

# Retrieves an auth code
module.exports.getAuthCode = (authCode, cb) ->
  AuthCodesModel.findOne { authCode: authCode }, cb

# Creates an auth code
module.exports.saveAuthCode = (code, clientId, expires, userId, cb) ->
  fields =
    clientId: clientId
    userId: userId
    expires: expires

  AuthCodesModel.update { authCode: code }, fields, { upsert: true }, (err) ->
    if err then console.error err
    cb err

mongoose.model "authCodes", AuthCodesSchema
AuthCodesModel = mongoose.model "authCodes"
