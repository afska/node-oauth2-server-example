mongoose = require("mongoose")
Schema = mongoose.Schema

OAuthUsersSchema = new Schema
  username:
    type: String
    unique: true
    required: true
  password:
    type: String
    required: true
  authorizations: [
    app: String
    scopes: String
  ]

# Creates an user
OAuthUsersSchema.static "register", (fields, cb) ->
  user = new OAuthUsersModel(fields)
  user.save cb

# Retrieves an user
OAuthUsersSchema.static "getUser", (username, password, cb) ->
  OAuthUsersModel.authenticate username, password, (err, user) ->
    if err or not user
      return cb(err)

    cb null, user.username

# Authenticates an user
OAuthUsersSchema.static "authenticate", (username, password, cb) ->
  @findOne { username: username }, (err, user) ->
    if err or not user
      return cb(err)

    passwordOk = password is user.password

    authenticatedUser = if passwordOk then user else null
    cb null, authenticatedUser

mongoose.model "users", OAuthUsersSchema
OAuthUsersModel = mongoose.model "users"

module.exports = OAuthUsersModel
