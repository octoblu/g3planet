AttendeeModel = require '../../models/attendee-model'
moment        = require 'moment'
_             = require 'lodash'

describe '->contructor', ->
  beforeEach ->
    @dataModel = find: sinon.stub()
    @sut = new AttendeeModel @dataModel

  it 'should exist', ->
    expect(@sut).to.exist
  
  describe '->getAttendees', ->
    describe 'when called without a project_id', ->
      beforeEach ->
        @error = new Error "Project ID required"
        @callback = sinon.spy()
        @project_id = undefined
        @pusk_id = '3dprinter'
        @vendorName = 'magical-wish-granting-orb'
        @startTime = '2015-02-22 10:00:00-0700'
        @endTime = '2015-02-22 11:00:00-0700'
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a pusk_id', ->
      beforeEach ->
        @error = new Error "Pusk ID required"
        @callback = sinon.spy()
        @project_id = 'old-well'
        @pusk_id = undefined
        @vendorName = 'magical-wish-granting-orb'
        @startTime = '2015-02-22 10:00:00-0700'
        @endTime = '2015-02-22 11:00:00-0700'
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a vendor_name', ->
      beforeEach ->
        @error = new Error "Vendor Name required"
        @callback = sinon.spy()
        @project_id = 'candy'
        @pusk_id = 'parasites'
        @vendorName = undefined
        @startTime = '2015-02-22 10:00:00-0700'
        @endTime = '2015-02-22 11:00:00-0700'
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a startTime and endTime', ->
      beforeEach ->
        @callback = sinon.spy()
        @project_id = 'gored-then-devoured'
        @pusk_id = 'tracks-pretty-awesome'
        @vendorName = 'something-cold'
        @startTime = undefined
        @endTime = undefined
        @searchQuery = 
          project_id: @project_id
          pusk_id: @pusk_id
          vendor_name: @vendorName
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should not pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

    describe 'when called with a startTime and endTime', ->
      beforeEach ->
        @callback = sinon.spy()
        @project_id = 'gored-then-devoured'
        @pusk_id = 'tracks-pretty-awesome'
        @vendorName = 'something-cold'
        @startTime = '2015-02-22 10:00:00-0700'
        @endTime = '2015-02-22 11:00:00-0700'
        @searchQuery = 
          project_id: @project_id
          pusk_id: @pusk_id
          vendor_name: @vendorName
          start_time: @startTime
          end_time: @endTime
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should not pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

    describe 'when called with a startTime later than endTime', ->
      beforeEach ->
        @error = new Error 'Invalid Date Range. Start time cannot be later than end time.'
        @callback = sinon.stub()
        @project_id = 'gored-then-devoured'
        @pusk_id = 'tracks-pretty-awesome'
        @vendorName = 'something-cold'
        @startTime = moment().add(7, 'days').format()
        @endTime = moment().format()
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error, null
        
        





        








      
    