AttendeeController = require './controllers/attendee-controller'
AttendeeModel      = require './models/attendee-model'
nedb               = require 'nedb'
cors               = require 'cors'

class Routes
  constructor: (@app) ->
    dataStore = new nedb()
    attendeeModel = new AttendeeModel dataStore
    @attendeeController = new AttendeeController attendeeModel
      
  register: =>
    @app.options '*', cors()
    @app.get  '/', (request, response) => response.status(200).send status: 'online'
    @app.post '/attendees', @attendeeController.getAttendees
    @app.post '/attendee/badge/:id', @attendeeController.getAttendeeByBadgeId
    @app.post '/attendee/registration/:id', @attendeeController.getAttendeeByRegId


module.exports = Routes
