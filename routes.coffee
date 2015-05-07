AttendeeController       = require './controllers/attendee-controller'
BetterAttendeeController = require './controllers/v2/attendee-controller'
AttendeeModel            = require './models/attendee-model'
Datastore = require 'nedb'
cors      = require 'cors'

if process.env.MONGODB_URI?
  mongo     = require 'mongojs'
  mongodb   = mongo(process.env.MONGODB_URI, ['attendees'])
  db = mongodb.attendees
else
  db = new Datastore {filename : './data/attendee.db', autoload: true}

class Routes
  constructor: (@app) ->
    attendeeModel = new AttendeeModel db
    @attendeeController = new AttendeeController attendeeModel
    @betterAttendeeController = new BetterAttendeeController attendeeModel

  register: =>
    @app.options '*', cors()
    @app.get  '/healthcheck', (request, response) => response.status(200).send status: 'online'
    @app.post '/attendees', @attendeeController.getAttendees
    @app.get '/attendee/badge/:id', @attendeeController.getAttendeeByBadgeId
    @app.get '/attendee/registration/:id', @attendeeController.getAttendeeByRegId

    @app.get '/v2/attendees', @betterAttendeeController.getAttendees
    @app.get '/v2/attendees/badges/:id', @betterAttendeeController.getAttendeeByBadgeId
    @app.get '/v2/attendees/registrations/:id', @betterAttendeeController.getAttendeeByRegId


module.exports = Routes
