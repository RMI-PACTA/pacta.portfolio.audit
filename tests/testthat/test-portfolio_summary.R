test_that("", {
  portfolio_total <- data.frame(
    asset_type = c("Equity", "Bonds", "Other"),
    financial_sector = c("Power", "Oil&Gas", "Automotive"),
    value_usd = 1:3,
    valid_input = TRUE
  )

  expected_output <- data.frame(
    asset_type = c("Equity", "Bonds", "Other"),
    financial_sector = c("Power", "Oil&Gas", "Automotive"),
    valid_input = TRUE,
    valid_value_usd = 1:3,
    asset_value_usd = 1:3,
    valid_value_usd = 6
  )

  output <- portfolio_summary(portfolio_total)
  expect_equal(output, expected_output, ignore_attr = TRUE)
})
