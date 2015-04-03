people = require './names'
attendeeTypes = require './attendee-types'
bestDescribes = require './best-describe'
companies = require './companies'
jobTitles = require './job-titles'
prtnrBusinessRelation = require './partner-business-relation'
primaryIndustry = require './primary-industry'
primaryRoles = require './primary-roles'
prtnrPrimaryRoles = require './prtnr-primary-roles'
moment = require 'moment'
_      = require 'lodash'
uuid   = require 'node-uuid'

Datastore = require 'nedb'
db = new Datastore {filename : './attendee.db', autoload: true}
puskId = uuid.v1()

randomNumber = (max) ->
  Math.floor(Math.random() * max)

time = moment().utc()

_.each people, (person) -> 
    registrationId = uuid.v4()
    badgeIds = registrationId.split('-')
    attendee = {                  
                 'reg_id': registrationId ,
                 'badge_ids': 
                    [
                      {'badge_id' : badgeIds[0]},
                      {'badge_id' : badgeIds[4]}
                    ]
                  'update_timestamp' : time.toDate()
                  'first_name' : person.firstName
                  'last_name'  : person.lastName
                  'company': companies[randomNumber(companies.length)]
                  'job_title': jobTitles[randomNumber(jobTitles.length)]
                  'cust_primary_role': primaryRoles[randomNumber(primaryRoles.length)]
                  'cust_primary_industry': primaryIndustry[randomNumber(primaryIndustry.length)]
                  'cust_best_describe': bestDescribes[randomNumber(bestDescribes.length)]
                  'prtnr_bus_relation': prtnrBusinessRelation[randomNumber(prtnrBusinessRelation.length)]
                  'part_primary_role': prtnrPrimaryRoles[randomNumber(prtnrPrimaryRoles.length)]
                }
    time.add(30, 'm')
    db.insert attendee, (error, newAttendee)->
      console.log 'Attendee inserted: ', newAttendee



