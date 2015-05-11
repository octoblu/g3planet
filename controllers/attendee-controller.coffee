config  = require '../config'
_       = require 'lodash'
debug        = require('debug') 'g3planet:AttendeeController'

class AttendeeController
  constructor: (@attendeeModel) ->

  getAttendees: (req, res) =>
    @attendeeModel.getAttendees req.body.beginning_timestamp, req.body.ending_timestamp, (error, attendees) =>

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
    @attendeeModel.getAttendeeByRegId req.params.id, (error, attendees) =>
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
