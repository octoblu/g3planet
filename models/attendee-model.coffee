_      = require 'lodash'
moment = require 'moment'

@ERROR_NO_PROJECT_ID  = 'Project ID required'
@ERROR_NO_PUSK_ID     = 'Pusk ID required'
@ERROR_NO_VENDOR_NAME = 'Vendor Name required'
@ERROR_INVALID_TIME   = 'Invalid Date Range. Start time cannot be later than end time.'

class AttendeeModel
  constructor : (@dataStore) ->

  getAttendees: (project_id, pusk_id, vendor_name, startTime, endTime, callback=->) =>
    return callback(new Error @ERROR_NO_PROJECT_ID, null) unless project_id
    return callback(new Error @ERROR_NO_PUSK_ID, null) unless pusk_id
    return callback(new Error @ERROR_NO_VENDOR_NAME, null) unless vendor_name

    queryOptions = 
      project_id  : project_id
      pusk_id     : pusk_id
      vendor_name : vendor_name

    queryOptions['start_time'] = startTime if startTime?
    queryOptions['end_time']   = endTime if endTime?

    if moment(startTime).isValid() and moment(endTime).isValid()
      error = new Error @ERROR_INVALID_TIME
      return callback(error, null) if moment(endTime).isBefore(startTime)
    
    @dataStore.find queryOptions

  getAttendeesByBadgeId: (project_id, pusk_id, vendor_name, badgeId , callback=->) =>
    return callback(null, [])
  
  getAttendeeByRegId: (project_id, pusk_id, vendor_name, registrationId , callback=->) =>
    return callback(null, [])
 


module.exports = AttendeeModel
