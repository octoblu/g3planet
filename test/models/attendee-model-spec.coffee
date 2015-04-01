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
        @callback = sinon.stub()
        @project_id = 'gored-then-devoured'
        @pusk_id = 'tracks-pretty-awesome'
        @vendorName = 'something-cold'
        @startTime = '2015-02-22 10:00:00-0700'
        @endTime = '2015-02-22 11:00:00-0700'
        @searchQuery = 
          project_id: @project_id
          pusk_id: @pusk_id
          vendor_name: @vendorName
          start_time: $gte: moment(@startTime).utc().unix()
          end_time: $lte: moment(@endTime).utc().unix()
        @data = 
          firstName: 'John'
          lastName: 'Connor'
        @dataModel.find.yields null, @data
        @sut.getAttendees @project_id, @pusk_id, @vendorName, @startTime, @endTime, @callback
      it 'should pass the startTime and endTime to the query options', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      it 'should return an object with attendees', ->
        expect(@callback).to.have.been.calledWith null, @data

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
      

  describe '-> getAttendeeByBadgeId', ->
    describe 'when called without a project_id', ->
      beforeEach ->
        @error      = new Error "Project ID required"
        @callback   = sinon.spy()
        @project_id = undefined
        @pusk_id    = 'red-dwarf'
        @vendorName = 'gimli-with-sunburn'
        @badgeId    = 1234
        @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a pusk_id', ->
      beforeEach ->
        @error = new Error "Pusk ID required"
        @callback = sinon.spy()
        @project_id = 'stellar-body'
        @pusk_id = undefined
        @vendorName = 'british-sitcom'
        @badgeId = 6789
        @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a vendor_name', ->
      beforeEach ->
        @error = new Error "Vendor Name required"
        @callback = sinon.spy()
        @project_id = 'exasperation'
        @pusk_id = 'freaking-believe-this'
        @vendorName = undefined
        @badgeId = 4321
        @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a badgeId', ->
      beforeEach ->
        @error = new Error "Badge ID required"
        @callback = sinon.spy()
        @project_id = 'speed'
        @pusk_id = 'high-velocity'
        @vendorName = 'dangerous-drug'
        @badgeId = undefined
        @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called with a valid badgeId', ->
      beforeEach ->
        @callback = sinon.stub()
        @project_id = 'something-intellectual'
        @pusk_id = 'bow-tie'
        @vendorName = 'opera-glasses'
        @badgeId = 5678
        @searchQuery = 
          project_id: @project_id
          pusk_id: @pusk_id
          vendor_name: @vendorName
          badge_ids: 
            $in: [badge_id: @badgeId]
        @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
      it 'should call dataModel.find with the correct query properties', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      describe 'when the database resolves', ->
        beforeEach ->
          @data = 
            firstName: 'Kyle'
            lastName: 'Reese'
          @dataModel.find.yields null, @data
          @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
        it 'should call the callback with the data', ->
          expect(@callback).to.have.been.calledWith null, @data

      describe 'when the database returns an error', ->
        beforeEach ->
          @dataModel.find.yields(new Error('ERRRRRRR'), null)
          @sut.getAttendeeByBadgeId @project_id, @pusk_id, @vendorName, @badgeId, @callback
        it 'should call the callback with the error', ->
          expect(@callback).to.have.been.calledWith new Error('ERRRRRRR'), null 
        
        


    

  describe '-> getAttendeeByRegId', ->
    describe 'when called without a project_id', ->
      beforeEach ->
        @error      = new Error "Project ID required"
        @callback   = sinon.spy()
        @project_id = undefined
        @pusk_id    = 'dirigible'
        @vendorName = 'hummingbird'
        @regId    = 1234
        @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a pusk_id', ->
      beforeEach ->
        @error = new Error "Pusk ID required"
        @callback = sinon.spy()
        @project_id = 'lawn-darts'
        @pusk_id = undefined
        @vendorName = 'chemical-compound'
        @regId = 6789
        @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a vendor_name', ->
      beforeEach ->
        @error = new Error "Vendor Name required"
        @callback = sinon.spy()
        @project_id = 'DNA'
        @pusk_id = 'H20'
        @vendorName = undefined
        @regId = 4321
        @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called without a registrationId', ->
      beforeEach ->
        @error = new Error "Registration ID required"
        @callback = sinon.spy()
        @project_id = 'TNT'
        @pusk_id = 'a-group-of-people'
        @vendorName = 'rabid-fanbase'
        @regId = undefined
        @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
      it 'should call the callback with an error', ->
        expect(@callback).to.have.been.calledWith @error

    describe 'when called with a valid registrationId', ->
      beforeEach ->
        @callback = sinon.spy()
        @project_id = 'extended-family'
        @pusk_id = 'your-enemies'
        @vendorName = 'papyrus'
        @regId = 1337
        @searchQuery = 
          project_id: @project_id
          pusk_id: @pusk_id
          vendor_name: @vendorName
          reg_id: @regId
        @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
      it 'should call dataModel.find with the correct search parameters', ->
        expect(@dataModel.find).to.have.been.calledWith @searchQuery

      describe 'when the database returns with an error', ->
        beforeEach ->
          @dataModel.find.yields(new Error('ERRORERROR'), null)
          @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
        it 'should call the callback with the error', ->
          expect(@callback).to.have.been.calledWith new Error('ERRORERROR'), null


      describe 'when the database returns with the data', ->
        beforeEach ->
          @data = 
            firstName: 'T'
            lastName: 'Rex'
          @dataModel.find.yields(null, @data)
          @sut.getAttendeeByRegId @project_id, @pusk_id, @vendorName, @regId, @callback
        it 'should call the callback with the data', ->
          expect(@callback).to.have.been.calledWith null, @data
          
        
        
      




