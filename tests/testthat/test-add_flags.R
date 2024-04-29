test_that("basic functionality works as expected", {
  portfolio <- data.frame(
    has_currency = c(FALSE, TRUE, TRUE, TRUE, TRUE),
    has_valid_input = c(TRUE, FALSE, TRUE, TRUE, TRUE),
    has_valid_isin = c(TRUE, TRUE, FALSE, TRUE, TRUE),
    has_fin_data = c(TRUE, TRUE, TRUE, FALSE, TRUE)
  )

  expected_output <- portfolio
  expected_output[["flag"]] <- c(
    "Missing currency information",
    "Negative or missing input value",
    "Invalid or missing ISIN",
    "Holding not in financial database",
    "Included in analysis"
  )

  output <- add_flags(portfolio)
  expect_equal(output, expected_output, ignore_attr = TRUE)
})
