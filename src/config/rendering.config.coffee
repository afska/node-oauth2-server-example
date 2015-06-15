express = require("express")

module.exports = (app) =>
  app.engine "html", require("ejs").renderFile
  app.use express.static "#{__dirname}/../../views"
  app.set "view engine", "html"
