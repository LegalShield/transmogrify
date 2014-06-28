Feature:
  In order to change an images filetype
  As a client of the app,
  I can request an image in a different filetype

  Scenario Outline: I can convert files
    When I request a <in> as:
      | type  |
      | <out> |
    Then I should receive an OK response
    And I should have received a <out>
    Examples:
      | in  | out  |
      | jpg | png  |
      | jpg | gif  |
      | png | jpeg |
      | png | gif  |
      | gif | png  |
      | gif | jpeg |
