mongoose = require("mongoose")
sha1 = require("sha1")
Schema = mongoose.Schema

UsersSchema = new Schema
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
UsersSchema.static "register", (fields, cb) ->
  user = new UsersModel(fields)
  user.save cb

# Retrieves an user
UsersSchema.static "getUser", (username, password, cb) ->
  UsersModel.authenticate username, password, (err, user) ->
    if err or not user then return cb(err)

    cb null, user.username

# Authenticates an user
UsersSchema.static "authenticate", (username, password, cb) ->
  UsersModel.findByName username, (err, user) ->
    if err or not user then return cb(err)

    passwordOk = sha1(password) is user.password

    authenticatedUser = if passwordOk then user else null
    cb null, authenticatedUser

# Finds an user
UsersSchema.static "findByName", (username, cb) ->
  @findOne { username: username }, cb

mongoose.model "users", UsersSchema
UsersModel = mongoose.model "users"

module.exports = UsersModel
