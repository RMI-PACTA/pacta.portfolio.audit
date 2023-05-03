test_that("`set_portfolio_parameters()` works as expected", {
  portfolio <- tibble::tribble(
    ~isin,          ~market_value, ~currency,
    "JP3868400007", 50000,         "GBP",
    "",             35184,         "GBP",
    NA,             28136,         "GBP",
  )

  fin_data <- tibble::tribble(
    ~isin,          ~company_id, ~bloomberg_id,
    "JP3868400007", 5643,        114116
  )

  # test that when portfolio data that has some unmatchable ISINs and it is
  # merged with fin data that add_fin_data() returns a data frame with the same
  # number of rows as the original portfolio data and that all the data stays
  # the same except for the new columns merged from the fin data; unmatched rows
  # should have appropriate NA values in the newly merged columns
  result <- add_fin_data(portfolio, fin_data)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(portfolio), nrow(result))
  expect_equal(result$isin, portfolio$isin)
  expect_equal(result$market_value, portfolio$market_value)
  expect_equal(result$currency, portfolio$currency)
  expect_equal(result$company_id, c(fin_data$company_id, NA_real_, NA_real_))
  expect_equal(result$bloomberg_id, c(fin_data$bloomberg_id, NA_real_, NA_real_))
})
