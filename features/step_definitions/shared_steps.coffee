Shared = require '../support/shared'
im     = require('gm').subClass(imageMagick: true)
expect = require('chai').expect

module.exports = ->
  @When /^I request a (.+) as:$/, (type, table, next) ->
    Shared.download "/image.#{type}", table.hashes()[0], next

  @Then /^I should have received an image with:$/, (table, next) ->
    im(Shared.data.filePath).size (err, info) ->
      return next err if err?
      for property, value of table.hashes()[0]
        expect("#{info[property]}", property).to.eql("#{value}")
      next err

  @Then /^I should receive an OK response$/, (next) ->
    expect(Shared.data.response.statusCode).to.eql(200)
    next()
