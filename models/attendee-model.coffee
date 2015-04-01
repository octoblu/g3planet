_      = require 'lodash'
moment = require 'moment'

@ERROR_NO_BADGE_ID    = 'Badge ID required'
@ERROR_NO_PROJECT_ID  = 'Project ID required'
@ERROR_NO_PUSK_ID     = 'Pusk ID required'
@ERROR_NO_REG_ID      = 'Registration ID required'
@ERROR_NO_VENDOR_NAME = 'Vendor Name required'
@ERROR_INVALID_TIME   = 'Invalid Date Range. Start time cannot be later than end time.'

class AttendeeModel
  constructor : (@dataModel) ->

  getAttendees: (project_id, pusk_id, vendor_name, startTime, endTime, callback=->) =>
    return callback(new Error @ERROR_NO_PROJECT_ID, null) unless project_id
    return callback(new Error @ERROR_NO_PUSK_ID, null) unless pusk_id
    return callback(new Error @ERROR_NO_VENDOR_NAME, null) unless vendor_name

    queryOptions = 
      project_id  : project_id
      pusk_id     : pusk_id
      vendor_name : vendor_name

    queryOptions['start_time'] = {$gte: moment(startTime).utc().unix()} if startTime?
    queryOptions['end_time']   = {$lte: moment(endTime).utc().unix()} if endTime?

    if moment(startTime).isValid() and moment(endTime).isValid()
      error = new Error @ERROR_INVALID_TIME
      return callback(error, null) if moment(endTime).isBefore(startTime)

    @dataModel.find queryOptions, (error, data) ->
      return callback(error, null) if error
      callback null, data

  getAttendeeByBadgeId: (project_id, pusk_id, vendor_name, badgeId , callback=->) =>
    return callback(new Error @ERROR_NO_PROJECT_ID, null) unless project_id
    return callback(new Error @ERROR_NO_PUSK_ID, null) unless pusk_id
    return callback(new Error @ERROR_NO_VENDOR_NAME, null) unless vendor_name
    return callback(new Error @ERROR_NO_BADGE_ID, null) unless badgeId

    queryOptions = 
      project_id  : project_id
      pusk_id     : pusk_id
      vendor_name : vendor_name
      badge_ids: 
        $in: [badge_id: badgeId]

    @dataModel.find queryOptions, (error, data) ->
      return callback(error, null) if error
      callback null, data

  getAttendeeByRegId: (project_id, pusk_id, vendor_name, registrationId , callback=->) =>
    return callback(new Error @ERROR_NO_PROJECT_ID, null) unless project_id
    return callback(new Error @ERROR_NO_PUSK_ID, null) unless pusk_id
    return callback(new Error @ERROR_NO_VENDOR_NAME, null) unless vendor_name
    return callback(new Error @ERROR_NO_REG_ID, null) unless registrationId

    queryOptions = 
      project_id  : project_id
      pusk_id     : pusk_id
      vendor_name : vendor_name
      reg_id      : registrationId

    @dataModel.find queryOptions, (error, data) ->
      return callback(error, null) if error
      callback null, data


module.exports = AttendeeModel
