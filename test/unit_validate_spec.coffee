Validate      = require '../lib/validate'
ValidationError = Validate.ValidationError


describe 'Unit::Validate', ->


  describe 'Class', ->

    describe 'Manage Tests', ->

      it 'should get a test', ->
        expect( Validate.getTest('testing') ).to.be.ok

      it 'should throw on a missing test', ->
        fn = -> Validate.getTest('testingno')
        expect( fn ).to.throw Error, /No test named "testingno" available/

      it 'should add a new test', ->
        expect( Validate.addTest('testingtwo', { test: (val)=> val }) ).to.be.ok

      it 'should run the new test', ->
        expect( Validate.a('testingtwo', true) ).to.be.true
        expect( Validate.a('testingtwo', false) ).to.be.false

      it 'should fail to add the same test', ->
        fn = -> Validate.addTest('testingtwo', { test: (val)=> val })
        expect( fn ).to.be.throw Error, /Test label "testingtwo" already exists/


    describe 'Dynamic Tests', ->

      it 'a string "test" alpha true', ->
        expect( Validate.string('alpha', 'test') ).to.be.true
      
      it 'string "test" alpha true', ->
        expect( Validate.string('alpha', 'test') ).to.be.true
      
      it 'string "test9" alpha true', ->
        expect( Validate.string('alpha', 'test9c') ).to.be.false

      it 'a number 3 range 1,5 true', ->
        expect( Validate.number('range', 3, 1,5) ).to.be.true
      
      it 'a number 1 range 3,5 false', ->
        expect( Validate.number('range', 1, 3,5) ).to.be.false

      it 'number 1 range 3,5 false', ->
        expect( Validate.a('range', 1, 3,5) ).to.be.false

      it 'number 1 between 3,5 false', ->
        expect( Validate.number('between', 1, 3,5) ).to.be.false

      it 'number 1 between 1,5 false', ->
        expect( Validate.a('between', 1, 1,5) ).to.be.false

      it 'number 2 between 1,5  true', ->
        expect( Validate.number('between', 2, 1,5) ).to.be.true

      it 'number 1 between 2,5  true', ->
        expect( Validate.number('between', 1, 2, 5) ).to.be.false

      it 'number group throws on missing', ->
        fn = -> Validate.number('match', 1, 2, 5)
        expect( fn ).to.throw Error

      it 'throws number 1 between 2,5  true', ->
        fn = -> Validate.andThrow('between', 1, 2, 5)
        expect( fn ).to.throw ValidationError, /Value must be between 2 and 5/
      
      it 'test types buffer via language', ->
        expect( Validate.language('buffer', new Buffer('')) ).to.be.true

      it 'test types buffer', ->
        expect( Validate.a('buffer', new Buffer('')) ).to.be.true
      
      it 'test types date', ->
        expect( Validate.a('date', new Date()) ).to.be.true
      
      it 'test types element', ->
        class Element
          nodeType: 1
        expect( Validate.an('element', new Element()) ).to.be.true
      
      it 'test types error', ->
        expect( Validate.an('error', new Error()) ).to.be.true
      
      it 'test types finite', ->
        expect( Validate.a('finite', 3) ).to.be.true
      
      it 'test types function', ->
        expect( Validate.a('function', new Function()) ).to.be.true
      
      it 'test types Map', ->
        expect( Validate.a('map', new Map()) ).to.be.true
      
      it 'test types Nan', ->
        expect( Validate.a('nan', NaN) ).to.be.true

      it 'test types number', ->
        expect( Validate.a('number', 3) ).to.be.true

      it 'test types object', ->
        expect( Validate.a('object', {}) ).to.be.true

      it 'test types plainobject', ->
        expect( Validate.a('plainobject', {}) ).to.be.true

      it 'test types regexp', ->
        expect( Validate.a('regexp', /\w/) ).to.be.true

      it 'test types safeinteger', ->
        expect( Validate.a('safeinteger', 5) ).to.be.true

      it 'test types string', ->
        expect( Validate.a('string', '') ).to.be.true

      it 'test types symbol', ->
        expect( Validate.a('symbol', Symbol.iterator) ).to.be.true

      it 'test types typedarray', ->
        expect( Validate.a('typedarray', new Uint8Array) ).to.be.true

      it 'test types weakmap', ->
        expect( Validate.a('weakmap', new WeakMap()) ).to.be.true

      it 'test types weakset', ->
        expect( Validate.a('weakset', new WeakSet()) ).to.be.true

      it 'test types nil', ->
        expect( Validate.a('nil', undefined ) ).to.be.true

      it 'test types notNil', ->
        expect( Validate.a('notNil', 5 ) ).to.be.true


    # Types moved into new test world
    describe 'Type Tests', ->

      describe 'Array', ->

        type_str = 'array'
        name_str = 'wakka'

        describe 'Boolean', ->

          it 'should validate an array', ->
            expect( Validate.as('array', [], name_str) ).to.be.true

          it 'should not validate a non array', ->
            expect( Validate.as('array', 'a', name_str) ).to.be.false


        describe 'Error', ->

          it 'should validate an array', ->
            expect( Validate.toMessage('array', [], name_str) ).to.be.undefined

          it 'should return msg on non array with name', ->
            fn = Validate.toMessage('array', '', name_str)
            expect( fn ).to.equal '"wakka" must be an array'

          it 'should return generic msg on non array without name', ->
            fn = Validate.toMessage('array', '')
            expect( fn ).to.equal 'Value must be an array'


        describe 'Throw', ->

          it 'should validate an array', ->
            expect( Validate.andThrow('array', [], name_str) ).to.be.true

          it 'should throw on non array with name', ->
            fn = -> Validate.andThrow('array', '', name_str)
            expect( fn ).to.throw ValidationError, '"wakka" must be an array'

          it 'should throw on non array without name', ->
            fn = -> Validate.andThrow('array', '')
            expect( fn ).to.throw ValidationError, 'Value must be an array'



      describe 'Boolean', ->

        type_str = 'boolean'
        name_str = 'michale'

        describe 'Boolean', ->

          it 'should validate an boolean', ->
            expect( Validate.as('boolean', true, name_str) ).to.be.true

          it 'should not validate a non boolean', ->
            expect( Validate.as('boolean', 'a', name_str) ).to.be.false


        describe 'Message', ->

          it 'should validate an boolean', ->
            expect( Validate.toMessage('boolean', false, name_str) ).to.be.undefined

          it 'should return msg on non boolean with name', ->
            fn = Validate.toMessage('boolean', '', name_str)
            expect( fn ).to.equal '"michale" must be a boolean'

          it 'should return generic msg on non boolean without name', ->
            fn = Validate.toMessage('boolean', '')
            expect( fn ).to.equal 'Value must be a boolean'


        describe 'Throw', ->

          it 'should validate an boolean', ->
            expect( Validate.andThrow('boolean', true, name_str) ).to.be.true

          it 'should throw on non boolean with name', ->
            fn = -> Validate.andThrow('boolean', '', name_str)
            expect( fn ).to.throw ValidationError, '"michale" must be a boolean'

          it 'should throw on non boolean without name', ->
            fn = -> Validate.andThrow('boolean', '')
            expect( fn ).to.throw ValidationError, 'Value must be a boolean'


      describe 'Integer', ->

        type_str = 'integer'
        name_str = 'the_int'

        describe 'Boolean', ->

          it 'should validate an integer', ->
            expect( Validate.as('integer', 5, name_str) ).to.be.true

          it 'should not validate a non integer', ->
            expect( Validate.as('integer', 5.5, name_str) ).to.be.false

          it 'should not validate a non integer', ->
            expect( Validate.as('integer', 'a', name_str) ).to.be.false


        describe 'Message', ->

          it 'should validate an integer', ->
            expect( Validate.toMessage('integer', 7, name_str) ).to.be.undefined

          it 'should return msg on non integer with name', ->
            fn = Validate.toMessage('integer', '', name_str)
            expect( fn ).to.equal '"the_int" must be an integer'

          it 'should return generic msg on non integer without name', ->
            fn = Validate.toMessage('integer', '')
            expect( fn ).to.equal 'Value must be an integer'


        describe 'Throw', ->

          it 'should validate an integer', ->
            expect( Validate.andThrow('integer', 6, name_str) ).to.be.true

          it 'should throw on non integer with name', ->
            fn = -> Validate.andThrow('integer', '', name_str)
            expect( fn ).to.throw ValidationError, '"the_int" must be an integer'

          it 'should throw on non integer without name', ->
            fn = -> Validate.andThrow('integer', '')
            expect( fn ).to.throw ValidationError, 'Value must be an integer'



      describe 'String', ->

        type_str = 'string'
        name_str = 'description'

        describe 'Boolean', ->

          it 'should validate an string', ->
            expect( Validate.as(type_str, 'test', name_str) ).to.be.true

          it 'should not validate a non string', ->
            expect( Validate.as(type_str, 5, name_str) ).to.be.false


        describe 'Message', ->

          it 'should validate an string', ->
            expect( Validate.toMessage(type_str, 'test', name_str) ).to.be.undefined

          it 'should return msg on non string with name', ->
            fn = Validate.toMessage(type_str, [], name_str)
            expect( fn ).to.equal '"description" must be a string'

          it 'should return generic msg on non string without name', ->
            fn = Validate.toMessage(type_str, true)
            expect( fn ).to.equal 'Value must be a string'


        describe 'Throw', ->

          it 'should validate an string', ->
            expect( Validate.andThrow('string', 'test', name_str) ).to.be.true

          it 'should throw on non string with name', ->
            fn = -> Validate.andThrow('string', 5, name_str)
            expect( fn ).to.throw ValidationError, '"description" must be a string'

          it 'should throw on non string without name', ->
            fn = -> Validate.andThrow('string', {})
            expect( fn ).to.throw ValidationError, 'Value must be a string'




    describe 'Length', ->

      it 'should return true for the length of string', ->
        expect( Validate.a('length', 'a', 1, 256, 'thestring') ).to.be.true

      it 'should return true for the length of string', ->
        expect( Validate.a('length', 'test', 4, 4, 'thestring') ).to.be.true

      it 'should return true for above the length of string', ->
        expect( Validate.a('length', 'test', 3, 5, 'thestring') ).to.be.true

      it 'should return false for below the length of string', ->
        expect( Validate.a('length', 'test', 3, 3, 'thestring') ).to.be.false

      it 'should return false for above the length of string', ->
        expect( Validate.a('length', 'test', 5, 5, 'thestring') ).to.be.false

      it 'should return true for only a min', ->
        expect( Validate.a('length', 'test',4) ).to.be.true

      it 'should return false for only a min above', ->
        expect( Validate.a('length', 'test',5) ).to.be.false

      it 'should return false for only a min below', ->
        expect( Validate.a('length', 'test',3) ).to.be.false

      it 'should return error message', ->
        msg = Validate.toMessage('length', 'test', 1, 5,'thestring')
        expect( msg ).to.be.undefined

      it 'should return error message', ->
        msg = Validate.toMessage('length', 'test', 5, 5,'thestring')
        expect( msg ).to.be.equal '"thestring" has length 4. Must be 5'

      it 'should return error message', ->
        msg = Validate.toMessage('length', 'tes', 4, 5, 'thestring')
        expect( msg ).to.be.equal '"thestring" has length 3. Must be 4 to 5'

      it 'should return error', ->
        res = Validate.toError('length', 'test', 1, 5,'thestring')
        expect( res ).to.be.undefined

      it 'should return error', ->
        err = Validate.toError('length', 'test', 5, 5,'thestring')
        expect( err ).to.be.instanceOf(ValidationError)
        expect( err.message ).to.equal '"thestring" has length 4. Must be 5'

      it 'should throw error', ->
        fn = -> Validate.andThrow('length', 'test', 1, 5,'thestring')
        expect( fn ).to.not.throw

      it 'should throw error', ->
        fn = -> Validate.andThrow('length', '3es', 4, 5,'thestring')
        expect( fn ).to.throw ValidationError, '"thestring" has length 3. Must be 4 to 5'


    describe 'Alpha', ->

      name_str = "thestring"
      name_str_msg = "\"#{name_str}\" "
      error_msg = "must only contain letters [ A-Z a-z ]"

      it 'should return true alpha', ->
        expect( Validate.string('alpha', 'ab', 'thestring') ).to.be.true

      it 'should return true alpha', ->
        expect( Validate.string('alpha', '59!#$%', 'thestring') ).to.be.false

      it 'should return true alpha', ->
        fn = -> Validate.string('integer', '59!#$%', 'thestring')
        expect( fn ).to.throw Error

      it 'should return error message', ->
        msg = Validate.toMessage('alpha', 'ab', 'thestring')
        expect( msg ).to.be.undefined

      it 'should return error message', ->
        msg = Validate.toMessage('alpha', 'a!b', 'thestring')
        expect( msg ).to.be.equal "#{name_str_msg}#{error_msg}"

      it 'should return error message', ->
        msg = Validate.toMessage('alpha', 'a!b')
        expect( msg ).to.be.equal "Value #{error_msg}"

      it 'should return error', ->
        res = Validate.toError('alpha', 'test', 'thestring')
        expect( res ).to.be.undefined

      it 'should return error', ->
        err = Validate.toError('alpha', 'test!', 'thestring')
        expect( err ).to.be.instanceOf(ValidationError)
        expect( err.message ).to.equal "#{name_str_msg}#{error_msg}"

      it 'should not throw error', ->
        expect( Validate.andThrow('alpha', 'test', 'thestring') ).to.be.true

      it 'should throw error', ->
        fn = -> Validate.andThrow('alpha', 'test!', 'thestring')
        expect( fn ).to.throw ValidationError, "#{name_str_msg}#{error_msg}"


    describe 'Numeric', ->

      name_str = "thestring"
      name_str_msg = "\"#{name_str}\" "
      error_msg = "must only contain numbers [ 0-9 ]"

      it 'should return true numeric', ->
        expect( Validate.string('numeric', '0939393', name_str) ).to.be.true

      it 'should return true numeric', ->
        expect( Validate.string('numeric', '59!#$%', name_str) ).to.be.false

      it 'should return error message', ->
        msg = Validate.toMessage('numeric', '2323', name_str)
        expect( msg ).to.be.undefined

      it 'should return error message', ->
        msg = Validate.toMessage('numeric', 'a!b', name_str)
        expect( msg ).to.be.equal "#{name_str_msg}#{error_msg}"

      it 'should return error message', ->
        msg = Validate.toMessage('numeric', 'a!b')
        expect( msg ).to.be.equal "Value #{error_msg}"

      it 'should return error', ->
        res = Validate.toError('numeric', '123453', name_str)
        expect( res ).to.be.undefined

      it 'should return error', ->
        err = Validate.toError('numeric', 'aaas', name_str)
        expect( err ).to.be.instanceOf(ValidationError)
        expect( err.message ).to.equal "#{name_str_msg}#{error_msg}"

      it 'should not throw error', ->
        expect( Validate.andThrow('numeric', '2', name_str) ).to.be.true

      it 'should throw error', ->
        fn = -> Validate.andThrow('numeric', 'test!', name_str)
        expect( fn ).to.throw ValidationError, "#{name_str_msg}#{error_msg}"


    describe 'alphaNumeric', ->

      name_str = "thestring"
      name_str_msg = "\"#{name_str}\" "
      error_msg = "must only contain letters and numbers [ A-Z a-z 0-9 ]"

      it 'should return true alpha numeric', ->
        expect( Validate.string('alphaNumeric', 'ab', name_str) ).to.be.true

      it 'should return true alpha numeric', ->
        expect( Validate.string('alphaNumeric', '59!#$%', name_str) ).to.be.false

      it 'should return error message', ->
        msg = Validate.toMessage('alphaNumeric', 'ab', name_str)
        expect( msg ).to.be.undefined

      it 'should return error message', ->
        msg = Validate.toMessage('alphaNumeric', 'a!b', name_str)
        expect( msg ).to.be.equal "#{name_str_msg}#{error_msg}"

      it 'should return error message', ->
        msg = Validate.toMessage('alphaNumeric', 'a!b')
        expect( msg ).to.be.equal "Value #{error_msg}"

      it 'should return error', ->
        res = Validate.toError('alphaNumeric', 'test', name_str)
        expect( res ).to.be.undefined

      it 'should return error', ->
        err = Validate.toError('alphaNumeric', 'test!', name_str)
        expect( err ).to.be.instanceOf(ValidationError)
        expect( err.message ).to.equal "#{name_str_msg}#{error_msg}"

      it 'should not throw error', ->
        expect( Validate.andThrow('alphaNumeric', 'test', name_str) ).to.be.true

      it 'should throw error', ->
        fn = -> Validate.andThrow('alphaNumeric', 'test!', name_str)
        expect( fn ).to.throw ValidationError, "#{name_str_msg}#{error_msg}"


    describe 'alphaNumericDashUnderscore', ->

      err_suffix = "must only contain letters, numbers, dash and underscore [ A-Z a-z 0-9 _ - ]"
      name_str = 'thestring'

      it 'should return true alpha numeric', ->
        expect( Validate.string('alphaNumericDashUnderscore', 'ab', name_str) ).to.be.true

      it 'should return true alpha numeric', ->
        expect( Validate.string('alphaNumericDashUnderscore', 'a!b', name_str) ).to.be.false

      it 'should return error message', ->
        msg = Validate.toMessage('alphaNumericDashUnderscore', 'ab', name_str)
        expect( msg ).to.be.undefined

      it 'should return error message', ->
        msg = Validate.toMessage('alphaNumericDashUnderscore', 'a!b', name_str)
        expect( msg ).to.be.equal "\"#{name_str}\" #{err_suffix}"

      it 'should return error', ->
        res = Validate.toError('alphaNumericDashUnderscore', 'test', name_str)
        expect( res ).to.be.undefined

      it 'should return error', ->
        err = Validate.toError('alphaNumericDashUnderscore', 'test!', name_str)
        expect( err ).to.be.instanceOf(ValidationError)
        expect( err.message ).to.equal "\"#{name_str}\" #{err_suffix}"

      it 'should throw error', ->
        fn = -> Validate.andThrow('alphaNumericDashUnderscore', 'test', name_str)
        expect( fn ).to.not.throw

      it 'should throw error', ->
        fn = -> Validate.andThrow('alphaNumericDashUnderscore', 'test!', name_str)
        expect( fn ).to.throw ValidationError, "\"#{name_str}\" #{err_suffix}"



    describe 'Defined', ->

      describe 'Boolean', ->

        it 'should validate a defined variable', ->
          expect( Validate.as('defined', [], 'somevar') ).to.be.true

        it 'should not validate a undefined value', ->
          expect( Validate.as('defined', undefined, 'somevar') ).to.be.false


      describe 'Message', ->

        it 'should not return a message for a defined variable', ->
          expect( Validate.toMessage('defined', 5, 'somevar') ).to.be.undefined

        it 'should return msg on undefined variable with name', ->
          fn = Validate.toMessage('defined', undefined, 'somevar')
          expect( fn ).to.equal '"somevar" must be defined'

        it 'should return generic msg on non string without name', ->
          fn = Validate.toMessage('defined', undefined)
          expect( fn ).to.equal 'Value must be defined'


      describe 'Throw', ->

        it 'should not throw on a defined variable', ->
          expect( Validate.andThrow('defined', 5, 'somevar') ).to.be.true

        it 'should throw on undefined variable with name', ->
          fn = -> Validate.andThrow('defined', undefined, 'somevar')
          expect( fn ).to.throw ValidationError, '"somevar" must be defined'

        it 'should throw on undefined variable without name', ->
          fn = -> Validate.andThrow('defined', undefined)
          expect( fn ).to.throw ValidationError, 'Value must be defined'



    describe 'Empty', ->

      describe 'Boolean', ->

        it 'should validate empty', ->
          expect( Validate.as('empty', '', 'label') ).to.be.true

        it 'should validate empty', ->
          expect( Validate.as('empty', [], 'label') ).to.be.true

        it 'should validate empty', ->
          expect( Validate.as('empty', {}, 'label') ).to.be.true

        it 'should validate empty', ->
          expect( Validate.as('empty', 7, 'label') ).to.be.true

        it 'should not validate a non empty', ->
          expect( Validate.as('empty', 'a', 'label') ).to.be.false

      describe 'Message', ->

        it 'should validate empty', ->
          expect( Validate.toMessage('empty', [], 'label') ).to.be.undefined

        it 'should return msg on non empty with name', ->
          fn = Validate.toMessage('empty', 'test', 'label')
          expect( fn ).to.equal '"label" must be empty'

        it 'should return generic msg on non empty without name', ->
          fn = Validate.toMessage('empty', 'test')
          expect( fn ).to.equal 'Value must be empty'

      describe 'Throw', ->

        it 'should validate empty', ->
          expect( Validate.andThrow('empty', [], 'label') ).to.be.true

        it 'should throw on non emtpy with name', ->
          fn = -> Validate.andThrow('empty', 'test', 'label')
          expect( fn ).to.throw ValidationError, '"label" must be empty'

        it 'should throw on non empty without name', ->
          fn = -> Validate.andThrow('empty', 'test')
          expect( fn ).to.throw ValidationError, 'Value must be empty'


    describe 'notEmpty', ->

      describe 'Boolean', ->

        it 'should validate empty string', ->
          expect( Validate.as('notEmpty', '', 'label') ).to.be.false

        it 'should validate empty array', ->
          expect( Validate.as('notEmpty', [], 'label') ).to.be.false

        it 'should validate empty object', ->
          expect( Validate.as('notEmpty', {}, 'label') ).to.be.false

        it 'should validate empty(?) number', ->
          expect( Validate.as('notEmpty', 7, 'label') ).to.be.false

        it 'should validate a non empty string', ->
          expect( Validate.as('notEmpty', 'a', 'label') ).to.be.true

      describe 'Message', ->

        it 'should validate not empty object', ->
          expect( Validate.toMessage('notEmpty', {a:1}, 'label') ).to.be.undefined

        it 'should return msg on non empty with name', ->
          fn = Validate.toMessage('notEmpty', '', 'label')
          expect( fn ).to.equal '"label" must not be empty'

        it 'should return generic msg on non empty without name', ->
          fn = Validate.toMessage('notEmpty', [])
          expect( fn ).to.equal 'Value must not be empty'

      describe 'Throw', ->

        it 'should validate non empty', ->
          expect( Validate.andThrow('notEmpty', 'iamnotempty', 'label') ).to.be.true

        it 'should throw on emtpy with name', ->
          fn = -> Validate.andThrow('notEmpty', {}, 'label')
          expect( fn ).to.throw ValidationError, '"label" must not be empty'

        it 'should throw on empty without name', ->
          fn = -> Validate.andThrow('notEmpty', [])
          expect( fn ).to.throw ValidationError, 'Value must not be empty'


    describe 'Undefined', ->

      type_str = 'undefined'
      name_str = 'somevar'

      describe 'Boolean', ->

        it 'should validate undefined', ->
          expect( Validate.as('undefined', undefined, name_str) ).to.be.true

        it 'should not validate a defined value', ->
          expect( Validate.as('undefined', 5, name_str) ).to.be.false

      describe 'Message', ->

        it 'should validate an undefined variable', ->
          expect( Validate.toMessage('undefined', undefined, name_str) ).to.be.undefined

        it 'should return msg on defined variable with name', ->
          fn = Validate.toMessage('undefined', [], name_str)
          expect( fn ).to.equal '"somevar" must be undefined'

        it 'should return generic msg on non string without name', ->
          fn = Validate.toMessage('undefined', true)
          expect( fn ).to.equal 'Value must be undefined'

      describe 'Throw', ->

        it 'should validate an undefined variable', ->
          expect( Validate.andThrow('undefined', undefined, name_str) ).to.be.true

        it 'should throw on defined variable with name', ->
          fn = -> Validate.andThrow('undefined', 5, name_str)
          expect( fn ).to.throw ValidationError, '"somevar" must be undefined'

        it 'should throw on defined variable without name', ->
          fn = -> Validate.andThrow('undefined', {})
          expect( fn ).to.throw ValidationError, 'Value must be undefined'


    describe 'between', ->

      it 'should between', ->
        expect( Validate.a('between',3,4,5) ).to.be.false
        expect( Validate.a('between',4,4,5) ).to.be.false
        expect( Validate.a('between',5,4,5) ).to.be.false
        expect( Validate.a('between',5,4,6) ).to.be.true


    describe 'range', ->

      it 'should range', ->
        expect( Validate.a('range',3,4,5) ).to.be.false
        expect( Validate.a('range',4,4,5) ).to.be.true
        expect( Validate.a('range',5,4,5) ).to.be.true
        expect( Validate.a('range',5,4,6) ).to.be.true


    describe 'match', ->

      it 'should match', ->
        expect( Validate.a('match','string',/string/) ).to.be.true
        expect( Validate.a('match','5',/5/) ).to.be.true


  # ## Instance

  describe 'Instance', ->


    describe 'creation', ->

      it 'should create an instance', ->
        expect( new Validate() ).to.be.an.instanceOf Validate


    describe 'properties', ->

      validate = null

      beforeEach ->
        validate = new Validate()

      it 'should default throw to true', ->
        expect( validate.throw ).to.be.true

      it 'should default error mode to false', ->
        expect( validate.error ).to.be.false

      it 'should default message mode to false', ->
        expect( validate.message ).to.be.false

      it 'should default results mode to false', ->
        expect( validate.result ).to.be.false

      it 'should default `mode` to throw', ->
        expect( validate.mode ).to.equal 'throw'

      it 'should get errors', ->
        expect( validate.errors ).to.eql []

      it 'should fail to set errors', ->
        fn = -> validate.errors = ['test']
        expect( fn ).to.throw Error, /errors should not be set/




    describe 'add', ->

      validate = null

      before ->
        validate = new Validate()

      it 'should add a test to validate', ->
        expect( validate.add('type','value','string','wakka') ).to.be.ok

      it 'should have a test in the array', ->
        expect( validate._tests.length ).to.equal 1


    describe 'run', ->

      validate = null

      before ->
        validate = new Validate()
        validate.add('string','value','wakka')

      it 'should run the tests', ->
        expect( validate.run() ).to.be.ok

      it 'should run the errors', ->
        expect( validate.errors ).to.eql []


    describe 'throw mode simples', ->

      validate = null

      before ->
        validate = new Validate()
        validate.add('string', 5, 'wakka')

      it 'should run the tests', ->
        fn = -> validate.run()
        expect( fn ).to.throw ValidationError

      it 'should run the errors', ->
        expect( validate.errors ).to.eql []


    describe 'throw mode simples with throw option', ->

      validate = null

      before ->
        validate = new Validate({ throw: true })
        validate.add('string', 5, 'wakka')

      it 'should run the tests', ->
        fn = -> validate.run()
        expect( fn ).to.throw ValidationError

      it 'should run the errors', ->
        expect( validate.errors ).to.eql []


    describe 'messages mode simples', ->

      validate = null

      before ->
        validate = new Validate({ messages: true })
        validate.add('string', 5, 'wakka')

      it 'should run the tests', ->
        expect( validate.run() ).to.be.ok

      it 'should run the errors', ->
        expect( validate.errors.length ).to.eql 1
        expect( validate.errors[0] ).to.match /wakka/


    describe 'errors mode extended', ->

      validate = null
      errors = null

      before ->
        validate = new Validate({ errors: true })
          .add('length', 'sa', 1, 256, 'dlen')
          .add('string', 5, 'dtype')
          .add('alphaNumericDashUnderscore', 'a!b', 'dstr')

      it 'should run the tests', ->
        expect( validate.run() ).to.be.ok

      it 'should contain errors after run', ->
        errors = validate.errors
        expect( errors ).to.be.an 'array'

      it 'should have a validation error for dtype', ->
        expect( errors[0] ).to.be.an.instanceOf ValidationError
        expect( errors[0].message ).to.equal '"dtype" must be a string'

      it 'should have a second validation error for dstr', ->
        expect( errors[1] ).to.be.an.instanceOf ValidationError
        expect( errors[1].message ).to.equal '"dstr" must only contain letters, numbers, dash and underscore [ A-Z a-z 0-9 _ - ]'

      it 'has the right number of errors', ->
        expect( errors.length ).to.eql 2


    describe 'messages', ->

      validate = null
      errors = null

      before ->
        validate = new Validate({messages: true})
          .add('length', 'sa', 1, 256, 'dlen')
          .add('string', 5, 'dtype')
          .add('testing', true, true, 'andtest')
          .add('alphaNumericDashUnderscore', 'a!b', 'dstr')

      it 'should run the tests', ->
        expect( validate.run() ).to.be.ok

      it 'should run the errors', ->
        errors = validate.errors
        expect( errors ).to.be.an 'array'

      it 'has a validation error', ->
        expect( errors[0] ).to.equal '"dtype" must be a string'

      it 'has a validation error', ->
        expect( errors[1] ).to.equal '"dstr" must only contain letters, numbers, dash and underscore [ A-Z a-z 0-9 _ - ]'

      it 'has the right number of errors', ->
        expect( errors.length ).to.eql 2



    describe 'results', ->

      validate = null
      errors = null

      before ->
        validate = new Validate({results: true})
          .add('length', 'sa', 1, 256, 'dlen')
          .add('string', 5, 'dtype')
          .add('alphaNumericDashUnderscore', 'a!b', 'dstr')

      it 'should run the tests', ->
        expect( validate.run() ).to.be.ok

      it 'should run the errors', ->
        errors = validate.errors
        expect( errors ).to.be.an 'array'

      it 'has a validation error', ->
        expect( errors[0] ).to.be.an 'array'
        .and.to.contain 'dtype'

      it 'has a validation error', ->
        expect( errors[1] ).to.be.an 'array'
        .and.to.contain 'dstr'

      it 'has the right number of errors', ->
        expect( errors.length ).to.eql 2

