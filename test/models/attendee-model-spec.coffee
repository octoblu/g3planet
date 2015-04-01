AttendeeModel = require '../../models/attendee-model'
_ = require 'lodash'

describe '->contructor', ->
  beforeEach ->
    @sut = new AttendeeModel()

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
        @startTime = '2015-02-22 10:10:00-0700'
        @endTime = '2015-02-22 10:10:00-0700'
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
        @startTime = '2015-02-22 10:10:00-0700'
        @endTime = '2015-02-22 10:10:00-0700'
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
        @startTime = '2015-02-22 10:10:00-0700'
        @endTime = '2015-02-22 10:10:00-0700'
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error
    