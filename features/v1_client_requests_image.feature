Feature:
  In order to get the image I want
  As a client of the app,
  I can resize an image on the fly

  Scenario: Client changes width on the fly
    When I request the portrait image as:
      | width |
      | 100   |
    Then I should have received an image with:
      | width |
      | 100   |
