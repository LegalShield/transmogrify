Feature:
  In order to get the image I want
  As a client of the app,
  I can resize an image on the fly

  Scenario: Client changes width on the fly
    When I request a png as:
      | width |
      | 100   |
    Then I should have received an image with:
      | width |
      | 100   |

  Scenario: Client changes height
    When I request a png as:
      | height |
      | 100    |
    Then I should have received an image with:
      | height |
      | 100    |

  Scenario: Client changes width and height and overrides aspect ratio
    When I request a png as:
      | height | width | transform |
      | 100    | 100   | !         |
    Then I should have received an image with:
      | height | width |
      | 100    | 100   |

  Scenario: Client transforms a jpeg
    When I request a jpg as:
      | height | width | transform |
      | 100    | 100   | !         |
    Then I should have received an image with:
      | height | width |
      | 100    | 100   |
