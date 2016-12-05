const Validate = require('deployable-validate')

let input = 3
let word = 'testing'
validate = new Validate({ throw: true })
  .add('numeric', '1345432')
  .add('alphaNumeric', 'asdf234324')
  .add('range', input, 1, 6, 'input')
  .add('match', word, /whatever/, 'word')
  .run()

