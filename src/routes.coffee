global.unauthorized = (res, message) ->
  res.writeHead 401
  res.end message

module.exports = (app) ->
  require("./controllers/oauthCtrl") app
  require("./controllers/mainCtrl") app
