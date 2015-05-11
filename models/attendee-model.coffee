_      = require 'lodash'
debug = require('debug') 'g3planet:AttendeeModel'

moment = null

@ERROR_NO_BADGE_ID    = 'Badge ID required'
@ERROR_NO_REG_ID      = 'Registration ID required'
@ERROR_INVALID_TIME   = 'Invalid Date Range. Start time cannot be later than end time.'

class AttendeeModel
  constructor : (@dataModel, dependencies={}) ->
    moment = dependencies.moment ? require 'moment'

  getAttendees: (startTime, endTime, callback=->) =>
    if moment(startTime).isValid() and moment(endTime).isValid()
      error = new Error @ERROR_INVALID_TIME
      return callback(error, null) if moment(endTime).isBefore(startTime)

    queryArray = []
    queryArray.push({'update_timestamp' : {$gte:  moment(startTime).toDate()} }) if startTime?
    queryArray.push({'update_timestamp' : {$lte:  moment(endTime).toDate()}}) if endTime?
    queryArray.push({'update_timestamp' : {$lte:  moment().toDate()}}) unless endTime?

    @dataModel.find {$and : queryArray}, (error, data) ->
      debug data
      return callback(error, null) if error
      callback null, data

  getAllAttendees: (callback=->) =>
    @dataModel.find {}, callback

  getAttendeeByBadgeId: (badgeId , callback=->) =>
    return callback(new Error @ERROR_NO_BADGE_ID, null) unless badgeId

    queryOptions =
      badge_ids:
        $in: [("" + badgeId).toUpperCase()]

    @dataModel.find queryOptions, (error, data) ->
      return callback(error, null) if error
      callback null, data

  getAttendeeByRegId: (registrationId , callback=->) =>
    return callback(new Error @ERROR_NO_REG_ID, null) unless registrationId

    queryOptions =
      reg_id      : registrationId

    @dataModel.find queryOptions, (error, data) ->
      return callback(error, null) if error
      callback null, data


module.exports = AttendeeModel
