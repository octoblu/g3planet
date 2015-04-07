config  = require '../config'
_       = require 'lodash'
debug        = require('debug') 'g3planet:AttendeeController'

class AttendeeController
  constructor: (@attendeeModel) ->

  getAttendees: (req, res) =>
    debug req.body
    console.log 'Request', req.body
    @attendeeModel.getAttendees req.body.beginning_timestamp, req.body.ending_timestamp, (error, attendees) =>
      console.log 'Results from model:', attendees

      return res.status(400).send error.message if error?.message
      result = {
        "attendee_data" : {
          "status" : "success"
          "message" : "attendee data"
          "num_records" : _.size(attendees)
          "request_values" : config
          attendees : attendees
        }
      }
      return res.status(200).send result

  getAttendeeByBadgeId: (req, res) =>
    @attendeeModel.getAttendeeByBadgeId req.params.id, (error, attendees) =>
      console.log 'Attendees result', attendees
      return res.status(400).send error.message  if error?.message
      result = {
        "attendee_data" : {
          "status" : "success"
          "message" : "attendee data"
          "num_records" : _.size(attendees)
          "request_values" : config
          attendees : attendees
        }
      }

      return res.status(200).send result unless error?



  getAttendeeByRegId: (req, res) =>
    console.log 'AttendeeController.getAttendeeByRegId called', req
    @attendeeModel.getAttendeeByRegId req.params.id, (error, attendees) =>
      console.log 'Attendees Found: ', attendees
      return res.status(400).send error.message  if error?.message
      result = {
      "attendee_data" : {
        "status" : "success"
        "message" : "attendee data"
        "num_records" : _.size(attendees)
        "request_values" : config
        attendees : attendees
        }
      }
      return res.status(200).send result unless error?


module.exports = AttendeeController
