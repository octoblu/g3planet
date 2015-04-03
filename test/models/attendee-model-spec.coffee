AttendeeModel = require '../../models/attendee-model'
moment        = require 'moment'
_             = require 'lodash'

describe '->contructor', ->
  beforeEach ->
    @dataModel = find: sinon.stub()
    @sut = new AttendeeModel @dataModel

  it 'should exist', ->
    expect(@sut).to.exist
  
  describe '-> getAttendees', ->
    describe 'when called without a startTime and endTime', ->
      beforeEach ->
        @callback = sinon.spy()
        @startTime = undefined
        @endTime = undefined
        @searchQuery = 
        { $and : [
          {'update_timestamp': {$lte: moment().utc().toDate()}}
          ]}
        @sut.getAttendees @startTime, @endTime, @callback
      it 'should not pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

    describe 'when called with a startTime and endTime', ->
      beforeEach ->
        @callback = sinon.stub()
        @startTime = moment().utc().format()
        @endTime = moment().add(3, 'h').utc().format()
        @searchQuery = 
         { $and : [
          {'update_timestamp': { $gte: moment(@startTime).utc().toDate()}}
          {'update_timestamp': {$lte: moment(@endTime).utc().toDate()}}
          ]}
          
        @data = 
          firstName: 'John'
          lastName: 'Connor'
        @dataModel.find.yields null, @data
        @sut.getAttendees  @startTime, @endTime, @callback
      it 'should pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      it 'should return an object with attendees', ->
        expect(@callback).to.have.been.calledWith null, @data

    describe 'when called with a startTime later than endTime', ->
      beforeEach ->
        @error = new Error 'Invalid Date Range. Start time cannot be later than end time.'
        @callback = sinon.stub()
        @startTime = moment().add(7, 'days').format()
        @endTime = moment().format()
        @sut.getAttendees @startTime, @endTime, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error, null
      

  describe '-> getAttendeeByBadgeId', ->
    describe 'when called without a badgeId', ->
      beforeEach ->
        @error = new Error "Badge ID required"
        @callback = sinon.spy()
        @badgeId = undefined
        @sut.getAttendeeByBadgeId @badgeId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called with a valid badgeId', ->
      beforeEach ->
        @callback = sinon.stub()
        @badgeId = 5678
        @searchQuery = 
          badge_ids: 
            $in: [badge_id: @badgeId]
        @sut.getAttendeeByBadgeId @badgeId, @callback
      it 'should call dataModel.find with the correct query properties', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      describe 'when the database resolves', ->
        beforeEach ->
          @data = 
            firstName: 'Kyle'
            lastName: 'Reese'
          @dataModel.find.yields null, @data
          @sut.getAttendeeByBadgeId  @badgeId, @callback
        it 'should call the callback with the data', ->
          expect(@callback).to.have.been.calledWith null, @data

      describe 'when the database returns an error', ->
        beforeEach ->
          @dataModel.find.yields(new Error('ERRRRRRR'), null)
          @sut.getAttendeeByBadgeId @badgeId, @callback
        it 'should call the callback with the error', ->
          expect(@callback).to.have.been.calledWith new Error('ERRRRRRR'), null 
        

  describe '-> getAttendeeByRegId', ->
    describe 'when called without a registrationId', ->
      beforeEach ->
        @error = new Error "Registration ID required"
        @callback = sinon.spy()
        @regId = undefined
        @sut.getAttendeeByRegId @regId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called with a valid registrationId', ->
      beforeEach ->
        @callback = sinon.spy()
        @regId = 1337
        @searchQuery = 
          reg_id: @regId
        @sut.getAttendeeByRegId @regId, @callback
      it 'should call dataModel.find with the correct search parameters', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      describe 'when the database returns with an error', ->
        beforeEach ->
          @dataModel.find.yields(new Error('ERRORERROR'), null)
          @sut.getAttendeeByRegId @regId, @callback
        it 'should call the callback with the error', ->
          expect(@callback).to.have.been.calledWith new Error('ERRORERROR'), null


      describe 'when the database returns with the data', ->
        beforeEach ->
          @data = 
            firstName: 'T'
            lastName: 'Rex'
          @dataModel.find.yields(null, @data)
          @sut.getAttendeeByRegId @regId, @callback
        it 'should call the callback with the data', ->
          expect(@callback).to.have.been.calledWith null, @data
          
        
        
      




