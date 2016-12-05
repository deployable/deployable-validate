// # Validate


// The main validation function return true when OK and false when validation failes
// `*Throw` returns true on ok and nothing on validation failure.

// The `*Message` and `*Error` functions/methods flip the return as they 
// are generating a message or error object.  They will return the 
// message or error if one exists. Otherwise they will return
// `undefined` when validation is ok, which is the logic opposite.


const _ = require('lodash')
const debug = require('debug')('dply:data:validate')

const {ValidationError} = require('deployable-errors')
const ValidateTest = require('./validate_test')
//const ValidateGroup = require('./validate_group')
const validate_config = require('./validate_config')




class Validate {

  // Attach data during load that es6 won't let me put in here
  // `.init` is called after the class definition
  static init(){
    // Init the tests in a class variable
    Validate._tests = {}
    _.forEach(validate_config, (test_details, test_name)=> {
      Validate.addTest(test_name, test_details)
    })
  }


  // ### Public methods

  // #### `.a` `.an` `.as(test_name, values..., name)`
  //
  // Main test runners `a` `an` `as`. Pick which one feels natural,
  // it changes on each type of validation test.
  // Returns `true` on ok. `false` on validation failure
  //
  // The last argument is an optional "name" for the value you
  // are checking so the error message are descriptive. This will
  // default to the generic `Value` if not supplied
  //
  // Usage:
  //
  //    Validate.a('string', 'test', 'mystring') => true
  //    Validate.a('string', 5, 'mystring') => false
  //    Validate.an('integer', 5, 'dollars') => true
  //    Validate.as('alpha', "qwertre4, 'username') => false

  static a(...args){ return Validate.as(...args) }
  static an(...args){ return Validate.as(...args) }
  static as(test, ...args){
    let mtest = Validate.getTest(test)
    let res = mtest.test(...args)
    return res
  }

  // Run a test and default to `throw` the `Error`
  // Otherwise `true`
  static andThrow(test_name, ...args){
    let test = Validate.getTest(test_name)
    let err = ( ! test.run(...args) ) ? test.getError(...args) : false
    if ( err ) throw err
    return true
  }

  // Run a test and return the error message, if any
  // Otherwise `undefined`
  static toMessage(test_name, ...args){
    let test = Validate.getTest(test_name)
    let msg = ( ! test.run(...args) ) ? test.getMessage(...args) : undefined
    return msg
  }

  // Run a test and return the error Object, if any
  // Otherwise `undefined`
  static toError(test_name, ...args){
    let test = Validate.getTest(test_name)
    let err = ( ! test.run(...args) ) ? test.getError(...args) : undefined
    return err
  }

  // #### `language(test_name, values..., name)`
  // #### `string(test_name, values..., name)`
  // #### `number(test_name, values..., name)`

  // Add semantic groups. Only runs the test if it's in that group
  // not populated from config :/
  // would be nice to have `Val.language.testname(args) too. check mocha

  static language(...args){ return Validate.runGroupTest('language', ...args) }
  static string(...args){ return Validate.runGroupTest('string', ...args) }
  static number(...args){ return Validate.runGroupTest('number', ...args) }

  // #### `getTest(test_nameString)`
  
  // Retreive a configured test
  static getTest(test_name){
    let test = Validate._tests[test_name]
    if (!test) throw Error(`No test named "${test_name}" available`)
    return test
  }

  // #### `addTest(test_nameString, configObject)`

  // Adds a new test, from json config

  //    let conf = { 
  //      args: ['value', 'expected'],
  //      test: (value, expected) => somethingBoolean(value, expected),
  //      message: "Something was {{value}}. Should have been {{expected}}"
  //    }
  //    Validate.addTest('expected', conf)

  static addTest(test_label, test_config){
    debug('Adding test config "%s". options:', test_label, test_config)
    if ( Validate._tests[test_label] ) throw new Error(`Test label "${test_label}" already exists`)
    let test = new ValidateTest(test_label, test_config)
    return Validate._tests[test.label] = test
  }


  // ### Not so public methods

  static runGroupTest(group_name, test, ...args){
    let group = Validate.getTest(test).group
    if (group !== group_name) throw new Error(`No test "${test}" in group "${group_name}"`)
    return Validate.as(test, ...args)
  }


  // ## Instance

  // The instance allows you to build suites of tests and run them as a group.
  // Useful for large forms or complex rule sets when you want to report all
  // errors to the user, not just the first

  constructor(options = {}){
    debug('creating Validation instance', options)
    
    // Store a suite of tests
    this._tests = []

    // Store test results
    this._results = []

    // Store test errors
    this._errors = []

    // Test mode
    // `throw` errors
    // Return an array of `error`
    // Return an array of `message`
    // Return an array of `boolean` test results
    if ( options.throw ) this.modeThrow()
    if ( options.errors ) this.modeErrors()
    if ( options.messages ) this.modeMessages()
    if ( options.results ) this.modeResults()
    if ( ! this.mode ) this.modeThrow()

  }

  modeThrow(){
    this.mode = 'throw'
    this.throw = true
    this.error = false
    this.message = false
    this.result = false
    this.function = 'andThrow'
  }
  modeErrors(){
    this.mode = 'errors'
    this.throw = false
    this.error = true
    this.message = false
    this.result = false
    this.function = 'toError'
  }
  modeMessages(){
    this.mode = 'message'
    this.throw = false
    this.error = false
    this.message = true
    this.result = false
    this.function = 'toMessage'
  }
  modeResults(){
    this.mode = 'results'
    this.throw = false
    this.error = false
    this.message = false
    this.result = true
    this.function = 'as'
  }


  // Add a test definition to array to be run
  // Type is require. args are dependent on the validation test
  add( test_type, ...args ){
    let test_def = [test_type, ...args]
    debug('add test_def', test_def)
    this._tests.push(test_def)
    return this
  }

  // Run all configure test on the instance
  run(){
    this._tests.forEach((test) => this.runTest(test))
    return this
  }

  // Run a single test
  runTest(test){
    let test_type = _.head(test)
    let args = _.tail(test)
    let result = Validate[this.function](test_type, ...args)
    debug('result mode thisres[%s] type[%s] valfn[%s] result[%s]', this.result, test_type, this.function, result)
    if (this.result) {
      // result mode stores all info about the result and test in an array
      this._results.push([result, ...test])
      if ( result !== true && result !== undefined ) this._errors.push([result, ...test])
    } else {
      // Otherwise just store what was returned 
      this._results.push(result)
      if ( result !== true && result !== undefined ) this._errors.push(result)
    }
    return result
  }

  get errors(){
    //if ( this._errors.length === 0 ) return false
    return this._errors
  }

  set errors(arg){
    throw new Error('errors should not be set', {arg:arg})
  }

}

// Allow vars to be attached to the class
Validate.init()

// Attach class variables
module.exports = Validate
module.exports.validate_config = validate_config

// Attach errors to the export
module.exports.ValidationError = ValidationError
