_ = require 'lodash'

class AttendeeController
  constructor: (@attendeeModel) ->

  getAttendees: (req, res) =>
    @attendeeModel.getAttendees null, null, (error,attendees) =>
      return res.status(500).send {error: 'Server Error'} if error?

      res.send attendees

  getAttendeeByBadgeId: (req, res) =>
    @attendeeModel.getAttendeeByBadgeId req.params.id, (error, attendees) =>
      return res.status(500).send {error: 'Server Error'} if error?
      return res.status(404).send {error: 'attendee not found'} if _.isEmpty attendees

      res.send _.first attendees

  getAttendeeByRegId: (req, res) =>
    @attendeeModel.getAttendeeByRegId req.params.id, (error, attendees) =>
      return res.status(500).send {error: 'Server Error'} if error?
      return res.status(404).send {error: 'attendee not found'} if _.isEmpty attendees

      res.send _.first attendees

module.exports = AttendeeController
