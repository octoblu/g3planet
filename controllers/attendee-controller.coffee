class AttendeeController
  getAttendees: (req, res) =>
    res.status(200).send 
      attendee:
        firstName: 'John'
        lastName: 'Connor'

module.exports = AttendeeController
