mongoose = require("mongoose")

mongoose.connect("mongodb://localhost/lepocamon-oauth");

#module.exports.oauth = require('./oauth');
module.exports.User = require('./user');
module.exports.App = require('./app');
module.exports.mongoose = mongoose;