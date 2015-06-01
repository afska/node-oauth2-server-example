AuthCode = require("./credentials/authCode")
AccessToken = require("./credentials/accessToken")
User = require("./user")
App = require("./app")

module.exports =
  getAuthCode: AuthCode.getAuthCode
  saveAuthCode: AuthCode.saveAuthCode
  getAccessToken: AccessToken.getAccessToken
  saveAccessToken: AccessToken.saveAccessToken
  getUser: User.getUser
  getClient: App.getClient
  grantTypeAllowed: App.grantTypeAllowed
