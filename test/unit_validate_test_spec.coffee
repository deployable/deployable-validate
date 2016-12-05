ValidateTest      = require '../lib/validate_test'
ValidationError = ValidateTest.ValidationError


describe 'Unit::ValidateTest', ->


  describe 'Class', ->

    it 'should create an instance', ->
      test = new ValidateTest('unit', { test: () -> true } )
      expect( test).to.be.an.instanceOf ValidateTest

    it 'should export ValidationError', ->
      expect( ValidateTest.ValidationError ).to.be.ok


  describe 'Instance', ->

    describe 'properties', ->

      test = null

      beforeEach ->
        test = new ValidateTest('unit', { test: () -> true } )

      it 'should have a label', ->
        expect( test.label ).to.equal 'unit'

      it 'should have a default string message', ->
        expect( test.message ).to.be.a 'string'

      it 'should have a default message', ->
        expect( test.message ).to.be.equal '{{name}} failed validation'

      it 'should have a template set', ->
        expect( test.template ).to.be.ok
        expect( test.template ).to.be.an.instanceOf(Function)

      it 'should have default arg of "value"', ->
        expect( test.arg_names ).to.be.eql ['value']

      it 'should have a default_value_name of Value', ->
        expect( test.default_value_name ).to.be.equal 'Value'

    
    describe '.messages', ->

      test = null

      beforeEach ->
        test = new ValidateTest('unit', { test: () -> true } )

      it 'should build a message from the default', ->
        expect( test.buildMessage({name:'blah'}) ).to.equal '"blah" failed validation'

      it 'should accept a new message', ->
        expect( test.message = 'yep').to.be.ok
        expect( test.buildMessage() ).to.equal 'yep'
        
      it 'should accept a new template message', ->
        expect( test.message = '{{one}}').to.be.ok
        expect( test.buildMessage({one:'giggidy'}) ).to.equal 'giggidy'
        
      it 'should accept a new function template message', ->
        expect( test.message = -> 'this is a message' ).to.be.ok
        expect( test.buildMessage({one:'giggidy'}) ).to.equal 'this is a message'

      it 'should accept a new function template message', ->
        test.message = (params)-> "#{params.one}"
        expect( test.buildMessage({one:'giggidy'}) ).to.equal 'giggidy'

      it 'shouldnt accept a template directly', ->
        fn = -> test.template = ''
        expect( fn ).to.throw Error, /The tests template can not be set directly/

      it 'should build a message from args', ->
        test.arg_names = ['value','arg']
        test.message = "{{value}} {{arg}} {{name}}"
        expect( test.buildMessageFromArgs('one','two','three') ).to.equal 'one two "three"'

      it 'should build a message without quotes', ->
        test.word_quotes = ''
        test.arg_names = ['value','arg']
        test.message = "{{value}} {{arg}} {{name}}"
        expect( test.buildMessageFromArgs('one','two','three') ).to.equal 'one two three'

      it 'should error on a bad message', ->
        fn = -> test.message = undefined
        expect( fn ).to.throw Error, /property must be a string or function/

      it 'should error on a bad _message', ->
        test._message = undefined
        fn = -> 
          test.buildMessage({name: 'something'})
        expect( fn ).to.throw Error, /property is the wrong type/


    describe '.test', ->

      test = null

      beforeEach ->
        test = new ValidateTest('unit', { test: () -> true } )

      it 'should accept a new test', ->
        expect( test.test = -> false ).to.be.ok

      it 'should run a new test', ->
        test.test = -> true
        expect( test.run() ).to.be.ok

      it 'should fail to set a bad test', ->
        fn = -> test.test = ''
        expect( fn ).to.throw Error, /The "test" property must be a function, not a string/


    describe '.group', ->

      test = null

      beforeEach ->
        test = new ValidateTest('unit', { test: () -> true } )

      it 'should accept a new group', ->
        expect(test.group = 'yep').to.be.ok

      it 'should accept a new group', ->
        test.group = 'yep'
        expect( test.group ).to.equal 'yep'


    describe '.arg_names', ->

      test = null

      beforeEach ->
        test = new ValidateTest('unit', { test: () -> true } )

      it 'should accept a arg_names', ->
        expect(test.arg_names = []).to.be.ok

      it 'should return new arg_names', ->
        test.arg_names = ['one']
        expect( test.arg_names ).to.eql ['one']

      it 'should fail to set bad arg_names', ->
        fn = -> test.arg_names = 'test'
        expect( fn ).to.throw Error, /"arg_names" must be an array/



    describe '.label', ->

      test = null

      beforeEach ->
        test = new ValidateTest('unit_label', { test: () -> true } )

      it 'should accept a arg_names', ->
        expect(test.label = 'other label').to.be.ok

      it 'should fail to set bad arg_names', ->
        fn = -> test.label = []
        expect( fn ).to.throw Error, /label must be a string. Got object/



    describe 'Test Runners', ->

      test = null

      beforeEach ->
        conf = {
          args: ['first', 'second'],
          test: (first, second) ->
            Boolean(first) && Boolean(second)
          ,
          message: '{{name}} testing ({{first}} && {{second}}) :D',
          group: 'testing'
        }
        test = new ValidateTest('testing', conf)

      it 'should return message on runMessage', ->
        expect( test.runMessage( false, false, 'b') )
          .to.equal '"b" testing (false && false) :D'

      it 'should return undefined on ok runMessage', ->
        expect( test.runMessage( true, true, 'b') ).to.be.undefined

      it 'should return error on runError', ->
        expect( test.runError( false, false, 'b') )
          .to.be.an.instanceOf ValidationError, /"b" testing \(false && false\) :D/

      it 'should return undefined on ok runMessage', ->
        expect( test.runError( true, true, 'b') ).to.be.undefined

      it 'should throw on runThrow', ->
        fn = -> test.runThrow( false, false, 'b')
        expect( fn ).to.throw Error, /"b" testing \(false && false\) :D/

      it 'should return true on ok runThrow', ->
        expect( test.runThrow( true, true, 'b') ).to.be.true