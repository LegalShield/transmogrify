Feature:
  In order to get the image I want
  As a client of the app,
  I can resize an image on the fly

  Scenario Outline: Works with many image types
    When I request a <in> as:
      | height | width | transform |
      | 100    | 100   | !         |
    Then I should receive an OK response
    And I should have received a <out>
    And I should have received an image with:
      | height | width |
      | 100    | 100   |
    Examples:
      | in   | out  |
      | jpg  | jpeg |
      | png  | png  |
      | jpeg | jpeg |
      | gif  | gif  |
