cors      = require 'cors'
AttendeeController = require './attendee-controller'

class Routes
  constructor: (@app) ->
     @attendeeController = new AttendeeController()
      
  register: =>
    @app.options '*', cors()
    @app.get  '/', (request, response) => response.status(200).send status: 'online'
    @app.post '/attendee', @attendeeController.getAttendees

module.exports = Routes
