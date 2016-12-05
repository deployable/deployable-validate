const Validate = require('deployable-validate')

let goodword = 'asdf'
let badword = 'a word'

Validate.as('alpha', goodword, "goodword")  // => true
Validate.as('alpha', badword, "badword")    // => false

let notint = 6.6

Validate.a('integer', notint )              // => false
Validate.toMessage('integer', notint )      // => "Value must be an integer"
Validate.toError('integer', notint )        // => ValidationError: "Value must be an integer"

Validate.andThrow('integer', notint ) 
//ValidationError: Value must be an integer
//    at ValidateTest.getError (/clones/deployable-validate/lib/validate_test.js:149:15)
//    at Function.andThrow (/clones/deployable-validate/lib/validate.js:68:46)
