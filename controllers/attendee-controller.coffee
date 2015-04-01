class AttendeeController
  constructor: (@attendeeModel) ->

  getAttendees: (req, res) =>
    @attendeeModel.getAttendees req.body.project_id, req.body.pusk_id, req.body.vendor_name, req.body.beginning_timestamp, req.body.ending_timestamp, (error, attendees) =>
      return res.status(400).send error.message if error?.message
      return res.status(200).send attendees unless error?


  getAttendeeByBadgeId: (req, res) =>
    @attendeeModel.getAttendeeByBadgeId req.body.project_id, req.body.badge_id, (error, attendees) =>
      return res.status(400).send error.message  if error
      return res.status(200).send attendees  unless error?

       

  getAttendeeByRegId: (req, res) =>
    @attendeeModel.getAttendeeByRegId req.body.project_id, req.body.reg_id, (error, attendees) =>
      return res.status(400).send error.message  if error
      return res.status(200).send attendees unless error?
      

module.exports = AttendeeController