
// # ValidateGroup


const _ = require('lodash')
const debug = require('debug')('dply:data:validate_group')
const {ValidateTest} = require('./validate_test')


module.exports = class ValidateGroup {
  
  build( tests ){
    _.forEach(tests, (test_name, test_details) => {
      let test = new ValidateTest(test_name, test_details)
      this._tests[test_name] = test
    })
  }

  constructor ( label, options = {} ) {
    this._label = label
    this._tests = {}
    this._welp = options.welp
  }

  get label () { return this._label }
  set label (str) { this._label = str }

  getTest ( test_label ) {
    let test = this._tests[test_label]
    if (!test) throw Error(`No test "${test_label}" in group "${this.label}"`)
    return test
  }

}
