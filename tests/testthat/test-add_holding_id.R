test_that("basic functionality works as expected", {
  portfolio <- data.frame(x = LETTERS[1:5])
  expected_output <- data.frame(x = LETTERS[1:5], holding_id = as.character(1:5))

  output <- add_holding_id(portfolio)
  expect_equal(output, expected_output)

  portfolio <- data.frame(x = LETTERS[1:5], holding_id = as.character(5:1))
  expected_output <- data.frame(x = LETTERS[1:5], holding_id = as.character(5:1))

  output <- add_holding_id(portfolio)
  expect_equal(output, expected_output)
})
