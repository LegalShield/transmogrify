Data   = require '../support/data'
Shared = require '../support/shared'
im     = require('gm').subClass(imageMagick: true)
expect = require('chai').expect

module.exports = ->
  @When /^I request (.+) as:$/, (name, table, next) ->
    Shared.selectorFor name, (path) ->
      Shared.download path, table.hashes()[0], next

  @Then /^I should have received an image with:$/, (table, next) ->
    im(Data.filePath).size (err, info) ->
      return next err if err?
      for property, value of table.hashes()[0]
        expect("#{info[property]}", property).to.eql("#{value}")
      next err
