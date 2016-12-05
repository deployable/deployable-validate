# deployable-validate

Validation helpers

``` javascript

const Validate = require('deployable-validate')

let goodword = 'asdf'
let badword = 'a word'
let int = 6
Validate.as('alpha', goodword, "goodword") // => true
Validate.as('alpha', badword, "badword")   // => false
Validate.a('integer', int )                // => false
Validate.toMessage('integer', int )        // => "Value must be an integer"
Validate.toError('integer', int )          // => ValidationError: "Value must be an integer"
Validate.andThrow('integer', int ) 
ValidationError: Value must be an integer
    at ValidateTest.getError (/clones/deployable-validate/lib/validate_test.js:149:15)
    at Function.andThrow (/clones/deployable-validate/lib/validate.js:68:46)
```

And 

``` javascript

let input = 3
validate = new Validate({ throw: true })
  .add('numeric', '1345432')
  .add('alphaNumeric'. 'asdf234324')
  .add('range', input, 1, 6, 'input')
  .run()

```

## run() Modes

#### `{ throw: true }`

Throw an error as it occurs. The default.

#### `{ error: true }`

Return all error objects

#### `{ message: true }`

Return all error message

#### `{ results: true }`

Return all results, including inputs as an array


###  Message templates

Error message can be customised via mustache style template strings.

Every test has a `value` to be tested and a `name` that default to `Value` if not supplied. 

    "Field {{name}} should be a X. Instead it was {{value}}"

Additional arguments can be names in each validation tests configuration. 

[lib/validate_config.js](https://github.com/deployable/deployable-validate/blob/master/lib/validate_config.js)

``` javascript

  match: {
    args: ['string', 'regex'],
    test: ( string, regex ) => ( _.isString(string) && Boolean(string.match(regex)) ),
    message: '{{name}} must match regular expression {{regex}}',
    group: 'string'
  }

```
