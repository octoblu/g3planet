config  = require '../config'
_       = require 'lodash'
debug        = require('debug') 'g3planet:AttendeeController'

class AttendeeController
  constructor: (@attendeeModel) ->

  getAttendees: (req, res) =>
    @attendeeModel.getAttendees req.body.beginning_timestamp, req.body.ending_timestamp, (error, attendees) =>
      return res.status(500).send error?.message if error?

      res.status(200).send {
        attendee_data:
          status: "success"
          message: "attendee data"
          num_records: _.size(attendees)
          request_values: config
          attendees: attendees
      }

  getAttendeeByBadgeId: (req, res) =>
    @attendeeModel.getAttendeeByBadgeId req.params.id, (error, attendees) =>
      return res.status(404).send error?.message if error?

      res.status(200).send {
        attendee_data:
          status: "success"
          message: "attendee data"
          num_records: _.size(attendees)
          request_values: config
          attendees: attendees
      }

  getAttendeeByRegId: (req, res) =>
    @attendeeModel.getAttendeeByRegId req.params.id, (error, attendees) =>
      return res.status(404).send error?.message  if error
      res.status(200).send {
        attendee_data:
          status: "success"
          message: "attendee data"
          num_records: _.size(attendees)
          request_values: config
          attendees: attendees
      }


module.exports = AttendeeController
