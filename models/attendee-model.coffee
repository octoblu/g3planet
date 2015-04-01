_ = require 'lodash'

@ERROR_NO_PROJECT_ID  = 'Project ID required'
@ERROR_NO_PUSK_ID     = 'Pusk ID required'
@ERROR_NO_VENDOR_NAME = 'Vendor Name required'

class AttendeeModel
  constructor : () ->

  getAttendees: (project_id, pusk_id, vendor_name, startTime, endTime, callback=->) =>
    return callback(new Error @ERROR_NO_PROJECT_ID, null) unless project_id
    return callback(new Error @ERROR_NO_PUSK_ID, null) unless pusk_id
    return callback(new Error @ERROR_NO_VENDOR_NAME, null) unless vendor_name
    return callback(null, [])
  
  getAttendeesByBadgeId: (project_id, pusk_id, vendor_name, badgeId , callback=->) =>
    return callback(null, [])
  
  getAttendeeByRegId: (project_id, pusk_id, vendor_name, registrationId , callback=->) =>
    return callback(null, [])
 


module.exports = AttendeeModel
