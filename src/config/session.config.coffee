session = require("express-session")
RedisStore = require("connect-redis")(session)

module.exports = (app) =>
  store = new RedisStore
    host: "parsimotion.redis.cache.windows.net"
    port: 6379
    prefix: "sess"
    pass: process.env.SESSION_REDIS_PASSWORD

  # Cookie parser
  signature = process.env.COOKIE_SIGNATURE
  app.use require("cookie-parser") signature

  # Shared session
  app.use require("express-session")
    key: process.env.SESSION_KEY
    store: store
    secret: process.env.SESSION_SECRET
    resave: true
    saveUninitialized: true
