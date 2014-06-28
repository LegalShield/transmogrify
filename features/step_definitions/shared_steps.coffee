Shared = require '../support/shared'
im     = require('gm').subClass(imageMagick: true)
expect = require('chai').expect

module.exports = ->
  @When /^I request a (.+) as:$/, (type, table, next) ->
    Shared.download "/image.#{type}", table.hashes()[0], next

  @Then /^I should have received an image with:$/, (table, next) ->
    for property, value of table.hashes()[0]
      expect("#{Shared.info.size[property]}", property).to.eql("#{value}")
    next()

  @Then /^I should have received a (.+)$/, (type, next) ->
    expect(type).to.eql(Shared.info.format.toLowerCase())
    next()

  @Then /^I should receive an OK response$/, (next) ->
    expect(Shared.response.statusCode).to.eql(200)
    next()
