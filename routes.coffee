AttendeeController = require './controllers/attendee-controller'
AttendeeModel      = require './models/attendee-model'
Datastore          = require 'nedb'
db                 = new Datastore {filename : './data/attendee.db', autoload: true}
cors               = require 'cors'

class Routes
  constructor: (@app) ->
    attendeeModel = new AttendeeModel db
    @attendeeController = new AttendeeController attendeeModel
      
  register: =>
    @app.options '*', cors()
    @app.get  '/', (request, response) => response.status(200).send status: 'online'
    @app.post '/attendees', @attendeeController.getAttendees
    @app.get '/attendee/badge/:id', @attendeeController.getAttendeeByBadgeId
    @app.get '/attendee/registration/:id', @attendeeController.getAttendeeByRegId


module.exports = Routes
