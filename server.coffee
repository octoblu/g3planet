express      = require 'express'
morgan       = require 'morgan'
errorHandler = require 'errorhandler'
bodyParser   = require 'body-parser'
cors         = require 'cors'
Routes       = require './routes'
debug        = require('debug') 'g3planet:server'

port = process.env.G3PLANET_API_PORT ? 9000

app = express()
app.use morgan('dev')
app.use errorHandler()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use cors()

routes = new Routes app
routes.register()

app.listen port, =>
  console.log "listening at localhost:#{port}"
