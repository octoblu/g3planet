AttendeeModel = require '../../models/attendee-model'
moment        = require 'moment'
_             = require 'lodash'

describe '->contructor', ->
  beforeEach ->
    @dataModel = find: sinon.stub()
    @toDate = sinon.stub()
    @isValid = sinon.stub()
    @isBefore = sinon.stub()
    @moment = => toDate: @toDate, isValid: @isValid, isBefore: @isBefore
    @request = sinon.stub()
    @sut = new AttendeeModel @dataModel, moment: @moment, request: @request, pusk_id: '123'

  it 'should exist', ->
    expect(@sut).to.exist

  describe '-> getAttendees', ->
    describe 'when called without a startTime and endTime', ->
      beforeEach ->
        @callback = sinon.spy()
        @startTime = undefined
        @endTime = undefined
        @toDate.returns new Date('2011-01-01')
        @searchQuery =
        { $and : [
          {'update_timestamp': {$lte: new Date('2011-01-01') }}
          ]}
        @sut.getAttendees @startTime, @endTime, @callback
      it 'should not pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

    describe 'when called with a startTime and endTime', ->
      beforeEach ->
        @callback = sinon.stub()
        @toDate.onCall(0).returns new Date('2013-01-01')
        @toDate.onCall(1).returns new Date('2014-01-01')
        @startTime = '2013-01-01'
        @endTime = '2014-01-01'
        @searchQuery =
         { $and : [
          {'update_timestamp': { $gte: new Date('2013-01-01')}}
          {'update_timestamp': { $lte: new Date('2014-01-01')}}
          ]}
        @data =
          firstName: 'John'
          lastName: 'Connor'
        @dataModel.find.yields null, @data
        @sut.getAttendees @startTime, @endTime, @callback

      it 'should pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      it 'should return an object with attendees', ->
        expect(@callback).to.have.been.calledWith null, @data

    describe 'when called with a startTime later than endTime', ->
      beforeEach ->
        @error = new Error 'Invalid Date Range. Start time cannot be later than end time.'
        @isValid.returns true
        @isBefore.returns true
        @callback = sinon.stub()
        @startTime = @toDate.returns(new Date('2014-01-01'))
        @endTime = @toDate.returns(new Date('2011-01-01'))
        @sut.getAttendees @startTime, @endTime, @callback

      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error, null


  describe '-> getAttendeeByBadgeId', ->
    describe 'when called without a badgeId', ->
      beforeEach ->
        @sut.getAttendeeByBadgeId undefined, (@error) =>

      it 'should call the callback with an error', ->
        expect(@error).to.deep.equal new Error "Badge ID required"

    describe 'when called with a valid badgeId', ->
      beforeEach ->
        @sut.getAttendeeByBadgeId 'a2e4', (@error, @result) =>

      it 'should call dataModel.find with the correct query properties', ->
        expect(@dataModel.find).to.have.been.calledWith badge_ids: {$in: ['A2E4']}

      it 'should call request with the correct parameters', ->
        expect(@request).to.have.been.calledWith {
          url: 'https://citrix.g2planet.com/synergyorlando2015/api_attendee_updates'
          method: 'POST'
          form:
            project_id: 'synergyorlando2015'
            api_version: 1
            vendor_name: 'XpoDigital'
            output_field_set: 'demographic'
            beginning_time_stamp: '2015-04-01 00:00:00'
            end_time_stamp: '2015-06-01 00:00:00'
            output_format: 'json'
            pusk_id: '123'
            badge_id: 'A2E4'
        }

      describe 'when the database resolves', ->
        beforeEach ->
          @dataModel.find.yield null, firstName: 'Kyle', lastName: 'Reese'

        it 'should call the callback with the data', ->
          expect(@result).to.deep.equal firstName: 'Kyle', lastName: 'Reese'

      describe 'when the database returns an error', ->
        beforeEach ->
          @dataModel.find.yield new Error('ERRRRRRR')

        describe 'when the request yields a result', ->
          beforeEach ->
            @request.yield null, {}, JSON.stringify(attendee_data: {num_records: 12, attendees: [{firstName: 'F', lastName: 'Sharp'}]})

          it 'should call the callback with the result', ->
            expect(@result).to.deep.equal [{firstName: 'F', lastName: 'Sharp'}]

        describe 'when the request yields an error', ->
          beforeEach ->
            @request.yield new Error 'oops'

          it 'should call the callback with an unknown error', ->
            expect(@error).to.deep.equal new Error 'unknown error'

  describe '-> getAttendeeByRegId', ->
    describe 'when called without a registrationId', ->
      beforeEach ->
        @sut.getAttendeeByRegId undefined, (@error) =>

      it 'should call the callback with an error', ->
        expect(@error).to.deep.equal new Error "Registration ID required"

    describe 'when called with a valid registrationId', ->
      beforeEach ->
        @callback = sinon.spy (@error, @result) =>
        @sut.getAttendeeByRegId 'ksdjf234', @callback

      it 'should call dataModel.find with the correct search parameters', ->
        expect(@dataModel.find).to.have.been.calledWith reg_id: "KSDJF234"

      it 'should call request with the correct parameters', ->
        expect(@request).to.have.been.calledWith {
          url: 'https://citrix.g2planet.com/synergyorlando2015/api_attendee_updates'
          method: 'POST'
          form:
            project_id: 'synergyorlando2015'
            api_version: 1
            vendor_name: 'XpoDigital'
            output_field_set: 'demographic'
            beginning_time_stamp: '2015-04-01 00:00:00'
            end_time_stamp: '2015-06-01 00:00:00'
            output_format: 'json'
            pusk_id: '123'
            reg_id: 'KSDJF234'
        }

      describe 'when the database returns with the data', ->
        beforeEach ->
          @dataModel.find.yield null, firstName: 'T', lastName: 'Rex'

        it 'should yield the data', ->
          expect(@result).to.deep.equal firstName: 'T', lastName: 'Rex'

      describe 'when the database returns with an error', ->
        beforeEach ->
          @dataModel.find.yield new Error('ERRORERROR')

        describe 'when the request yields a result', ->
          beforeEach ->
            @request.yield null, {}, JSON.stringify(attendee_data: {num_records: 12, attendees: [{firstName: 'F', lastName: 'Sharp'}]})

          it 'should yield the result', ->
            expect(@result).to.deep.equal [{firstName: 'F', lastName: 'Sharp'}]

          it 'should only have called the callback once', ->
            expect(@callback).to.have.been.calledOnce
