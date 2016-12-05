
// # ValidateTest

// House the details and methods for a configured test.

const _ = require('lodash')
const debug = require('debug')('dply:data:validate_test')
const {ValidationError} = require('deployable-errors')


module.exports = class ValidateTest {

  constructor ( label, options = {} ) {
    
    // Label/name of test - required
    this.label = label

    // Template options for _.template (set before `.message`!)
    // Defaults to mustache `{{var}}`
    this.template_options = options.template_options || { interpolate: /{{([\s\S]+?)}}/g }

    // The test function to use - required
    // Any function that returns true/false
    this.test = options.test

    // The string template to use as a message, or function to return string message
    this.message = options.message || '{{name}} failed validation'

    // Names of arguments, used for the message/templates
    this.arg_names = options.arg_names || options.args || ['value']

    // A group this test belongs to.
    this.group = options.group || 'none'

    // The default name of the value when one is not passed in
    this.default_value_name = options.default_value_name || 'Value'

    // Modify the quoting of names/words
    this.word_quotes = options.word_quotes || '"'

  }


  // ## Getters/Setters
  // All of them

  // #### `label`
  get label() { return this._label }
  set label(str) { 
    if ( !_.isString(str) ) throw new Error(`The tests label must be a string. Got ${typeof str}`)
    this._label = str
  }

  // #### `template_options`
  get template_options(){ return this._template_options }
  set template_options(opts){ 
   debug('setting template options', opts)
    this._template_options = opts
  }

  // #### `test`
  get test() { return this._test }
  set test(test_fn) { 
    if ( ! _.isFunction(test_fn) ) throw new Error(`The "test" property must be a function, not a ${typeof test_fn}`)
    this._test = test_fn
  }

  // #### `message`
  get message(){ return this._message}
  // Set a new template string/fn for the message
  set message(msg){
    if ( ! _.isString(msg) && ! _.isFunction(msg) ) 
      throw new Error(`The tests "message" property must be a string or function, not a ${typeof msg}`)
    this._message = msg
    if ( _.isString(msg) ) this.compileTemplate()
  }

  // #### `template`
  get template(){ return this._template }
  set template(tmpl){
    throw Error('The tests template can not be set directly. Set the template string in "message"')
  }

  // #### `arg_names`
  get arg_names() { return this._arg_names }
  set arg_names(args) { 
    if ( !_.isArray(args) ) throw new Error('The tests "arg_names" must be an array')
    this._arg_names = args
  }

  // #### `group`
  get group() { return this._group }
  set group(str) { this._group = str }

  // #### `word_quotes`
  get word_quotes() { return this._word_quotes }
  set word_quotes(str) { this._word_quotes = str }

  // #### `default_value_name`
  get default_value_name() { return this._default_value_name }
  set default_value_name(str) { this._default_value_name = str }
    

  // ## Public Methods

  // Return `true` when test passes
  // `false` when test fails
  run (...args) {
    return this.test(...args)
  }

  // Throw an error when the test fails 
  // return `true` other wise
  runThrow (...args) {
    let res = this.run(...args)
    if (!res) return this.throwError(...args)
    return true
  }

  // The logic is flipped on Message and Error. 
  // An Error message will be returned on failure
  // `undefined` when things are ok. 
  runMessage (...args) {
    let res = this.run(...args)
    if (!res) return this.getMessage(...args)
    return undefined
  }

  // The logic is flipped on Message and Error. 
  // An Error will be returned on failure
  // `undefined` when things are ok. 
  runError (...args) {
    let res = this.run(...args)
    if (!res) return this.getError(...args)
    return undefined
  }



  // Get the Error Message without running the test
  getMessage(...args){
    return this.buildMessageFromArgs(...args)
  }

  // Get the Error Object without running the test
  getError(...args){
    let params = this.argsToParams(...args)
    let msg = this.buildMessage(params)
    let err = new ValidationError(msg, params)
    return err
  }

  // Throw the Error without running the test
  throwError(...args){
    let err = this.getError(...args)
    throw err
  }



  // ## Private methods

  // Runs when you set a `.message`
  compileTemplate(){
    debug('template compiled for "%s" [%s]. options: ', this.label, this._message, this.template_options)
    return this._template = _.template(this._message, this._template_options)
  }

  // Fill the template with values
  buildMessage( params = {} ){
    params.name = this.strOrValue(params.name)
    debug('building message with for %s', this.label, params)
    if ( _.isString(this.message) ) return this.template(params)
    if ( _.isFunction(this.message) ) return this.message(params)
    throw new Error(`The tests "message" property is the wrong type "${typeof this.message}`)
  }

  // Fill the template with values
  buildMessageFromArgs( ...args ){
    let params = this.argsToParams(...args)
    return this.buildMessage(params)
  }

  // Create a name:value object from an array of function argument 
  // names, and an array of argument values
  // This is used for template generation
  argsToParams(...args){
    // `['a','b'] [1,2]` becomes `{ a:1, b:2 }`
    return _.zipObject( ['test', ...this.arg_names, 'name'], [this.label, ...args] )
  }

  // Defaults a str to Value, or surrounds str in quotes. 
  // For message output
  strOrValue(str){
    let quote = this.word_quotes
    return ( str === undefined ) ? this.default_value_name :  `${quote}${str}${quote}`
  }


}


module.exports.ValidationError = ValidationError