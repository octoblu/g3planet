_      = require 'lodash'
async  = require 'async'
debug = require('debug') 'g3planet:AttendeeModel'

moment = null
request = null

@ERROR_NO_BADGE_ID    = 'Badge ID required'
@ERROR_NO_REG_ID      = 'Registration ID required'
@ERROR_INVALID_TIME   = 'Invalid Date Range. Start time cannot be later than end time.'

class AttendeeModel
  G2_URL: 'https://citrix.g2planet.com/synergyorlando2015/api_attendee_updates'

  constructor : (@dataModel, dependencies={}) ->
    moment = dependencies.moment ? require 'moment'
    request = dependencies.request ? require 'request'
    @pusk_id = dependencies.pusk_id ? process.env.pusk_id

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
    badgeId = ("" + badgeId).toUpperCase()

    async.parallel
      one: (cb=->) =>
        @dataModel.find badge_ids: $in: [badgeId], (error, data) ->
          return cb null, error if error?
          callback null, data
          callback = ->
      two: (cb=->) =>
        request @requestBadgeIdParams(badgeId), (error, response, body) =>
          return cb null, error if error?
          callback null, body.attendee_data.attendees
          callback = ->
    , (error, errors) =>
      return callback error if error?
      callback new Error 'unknown error'

  getAttendeeByRegId: (registrationId , callback=->) =>
    return callback(new Error @ERROR_NO_REG_ID, null) unless registrationId
    registrationId = ("" + registrationId).toUpperCase()

    async.parallel
      one: (cb=->) =>
        @dataModel.find reg_id: registrationId, (error, data) ->
          return cb null, error if error?
          callback null, data
          callback = ->
      two: (cb=->) =>
        request @requestRegIdParams(registrationId), (error, response, body) =>
          return cb null, error if error?
          callback null, body.attendee_data.attendees
          callback = ->
    , (error, errors) =>
      return callback error if error?
      callback new Error 'unknown error'


  requestBadgeIdParams: (badgeId) =>
    url: @G2_URL
    form:
      badge_id: badgeId
      pusk_id: @pusk_id
      project_id: 'synergyorlando2015'
      api_version: 1
      vendor_name: 'XpoDigital'
      output_field_set: 'demographic'
      beginning_time_stamp: '2015-04-01 00:00:00'
      end_time_stamp: '2015-06-01 00:00:00'
      output_format: 'json'

  requestRegIdParams: (registrationId) =>
    url: @G2_URL
    form:
      reg_id: registrationId
      pusk_id: @pusk_id
      project_id: 'synergyorlando2015'
      api_version: 1
      vendor_name: 'XpoDigital'
      output_field_set: 'demographic'
      beginning_time_stamp: '2015-04-01 00:00:00'
      end_time_stamp: '2015-06-01 00:00:00'
      output_format: 'json'


module.exports = AttendeeModel
