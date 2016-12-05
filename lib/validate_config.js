// # Validate Config

// Contains the config for all the different validation tests
// This is loaded as `validate_config` into the `Validate` class at require time. 

// A lot of the tests are based on [lodash](https://lodash.com/docs/) methods.

const _ = require('lodash')


module.exports = {

  // It got a bit too meta here
  // type: {
  //   args: ['type', 'value', '...args'],
  //   test: ( type, value, ...args ) => Validate.type( type, value, ...args ),
  //   //message: '{{name}} {{type}} mismatch for {{value}}'
  //   message: (params) => Validate.typeMessage(params.test)
  // },

  array: {
    args: ['value'],
    test: _.isArray,
    message: '{{name}} must be an array',
    group: 'language'
  },
  boolean: {
    args: ['value'],
    test: _.isBoolean,
    message: '{{name}} must be a boolean',
    group: 'language'
  },
  buffer: {
    args: ['value'],
    test: _.isBuffer,
    message: '{{name}} must be a buffer',
    group: 'language'
  },
  date: {
    args: ['value'],
    test: _.isDate,
    message: '{{name}} must be a date',
    group: 'language'
  },
  element: {
    args: ['value'],
    test: _.isElement,
    message: '{{name}} must be an element',
    group: 'language'
  },
  error: {
    args: ['value'],
    test: _.isError,
    message: '{{name}} must be an error',
    group: 'language'
  },
  finite: {
    args: ['value'],
    test: _.isFinite,
    message: '{{name}} must be finite'
  },
  function: {
    args: ['value'],
    test: _.isFunction,
    message: '{{name}} must be a function',
    group: 'language'
  },
  map: {
    args: ['value'],
    test: _.isMap,
    message: '{{name}} must be a map',
    group: 'language'
  },
  nan: {
    args: ['value'],
    test: _.isNaN,
    message: '{{name}} must be Not A Number',
    group: 'language'
  },
  number: {
    args: ['value'],
    test: _.isNumber,
    message: '{{name}} must be a Number',
    group: 'language'
  },
  object:     {
    args: ['value'],
    test: _.isObject,
    message: '{{name}} must be an object',
    group: 'language'
  },
  plainobject: {
    args: ['value'],
    test: _.isPlainObject,
    message: '{{name}} must be a plain object',
    group: 'language'
  },
  regexp:     {
    args: ['value'],
    test: _.isRegExp,
    message: '{{name}} must be a Regular Expression',
    group: 'language'
  },
  safeinteger:{
    args: ['value'],
    test: _.isSafeInteger,
    negate: 'an unsafe integer',
    message: '{{name}} must be a safe integer'
  },
  set:        {
    args: ['value'],
    test: _.isSet,
    message: '{{name}} must be a set',
    group: 'language'
  },
  string:     {
    args: ['value'],
    test: _.isString,
    message: '{{name}} must be a string',
    group: 'language'
  },
  symbol:     {
    args: ['value'],
    test: _.isSymbol,
    message: '{{name}} must be a symbol',
    group: 'language'
  },
  typedarray: {
    args: ['value'],
    test: _.isTypedArray,
    message: '{{name}} must be a typed array',
    group: 'language'
  },
  weakmap:    {
    args: ['value'],
    test: _.isWeakMap,
    message: '{{name}} must be a weak map',
    group: 'language'
  },
  weakset:    {
    args: ['value'],
    test: _.isWeakSet,
    message: '{{name}} must be a weak set',
    group: 'language'
  },
  nil:        { 
    args: ['value'],
    test: _.isNil,
    message: '{{name}} must be nil'
  },
  notNil:        { 
    args: ['value'],
    test: (value) => !_.isNil(value),
    message: '{{name}} must not be nil'
  },
  empty: { 
    args: ['value'],
    test: _.isEmpty,
    join: '',
    name: 'Value',
    message: '{{name}} must be empty'
  },
  notEmpty: { 
    args: ['value'],
    test: (value) => !_.isEmpty(value),
    join: '',
    name: 'Value',
    message: '{{name}} must not be empty'
  },
  undefined:  { 
    args: ['value'],
    test: _.isUndefined,    
    negate: 'defined',  
    name: 'Value',
    message: '{{name}} must be undefined'
  },
  defined: { 
    args: ['value'],
    test: (val) => !_.isUndefined(val),
    negate: 'undefined',
    name: 'Value',
    message: '{{name}} must be defined'
  },


  length: {
    args: ['value', 'min', 'max'],
    test: (value, min, max) => {
      if (max === undefined ) max = min
      let size =  _.size(value)
      return ( size >= min && size <= max )
    },
    //message: '{{name}} must be {{min}} to {{max}}'
    message: (p) => {
      let msg = `${p.name} has length ${p.value.length}.`
      msg += ( p.min === p.max ) ? ` Must be ${p.min}` : ` Must be ${p.min} to ${p.max}`
      return msg
    }
  },


  integer: {
    args: ['value'],
    test: _.isInteger,
    message: '{{name}} must be an integer',
    group: 'number'
  },
  range: {
    args: ['value','min','max'],
    test: (value, min, max) => ( value >= min && value <= max ),
    message: '{{name}} must be in {{min}} .. {{max}}',
    group: 'number'
  },
  between: {
    args: ['value','min','max'],
    test: (value, min, max) => ( value > min && value < max ),
    message: '{{name}} must be between {{min}} and {{max}}',
    group: 'number'
  },


  match: {
    args: ['string', 'regex'],
    test: ( string, regex ) => ( _.isString(string) && Boolean(string.match(regex)) ),
    message: '{{name}} must match regular expression {{regex}}',
    group: 'string'
  },
  alphaNumericDashUnderscore: {
    args: ['string'],
    test: (string) => ( _.isString(string) && Boolean(string.match(/^[A-Za-z0-9_-]+$/)) ),
    message: '{{name}} must only contain letters, numbers, dash and underscore [ A-Z a-z 0-9 _ - ]',
    group: 'string'
  },
  alphaNumeric: { 
    args: ['string'],
    test: (string) => ( _.isString(string) && Boolean(string.match(/^[A-Za-z0-9]+$/)) ),
    message: '{{name}} must only contain letters and numbers [ A-Z a-z 0-9 ]',
    group: 'string'
  },
  alpha: { 
    args: ['string'],
    test: (string) => ( _.isString(string) && Boolean(string.match(/^[A-Za-z]+$/)) ),
    message: '{{name}} must only contain letters [ A-Z a-z ]',
    group: 'string'
  },
  numeric: { 
    args: ['string'],
    test: (string) => ( _.isString(string) && Boolean(string.match(/^[0-9]+$/)) ),
    message: '{{name}} must only contain numbers [ 0-9 ]',
    group: 'string'
  },


  testing: { 
    args: ['first', 'second'],
    test: (first, second) => Boolean(first) && Boolean(second),
    message: '{{name}} testing ({{value}} && {{second}}) :D',
    group: 'testing'
  }
}
