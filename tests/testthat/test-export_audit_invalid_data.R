test_that("basic functionality works as expected", {
  flags <- c(
    "Missing currency information",
    "Negative or missing input value",
    "Invalid or missing ISIN",
    "XXX",
    NA,
    "Invalid or missing ISIN"
  )
  portfolio_total_ <- data.frame(
    isin = c("ABC123", "DEF456", "GHI789", "JKL012", "MNO345", "PQR678"),
    market_value = 1:6,
    currency = "USD",
    flag = flags,
    direct_holding = c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)
  )
  export_path_full <- withr::local_tempdir()

  export_audit_invalid_data(portfolio_total_, paste0(export_path_full, "/invalidsecurities"))

  expected_output <- list(
    isin = list("GHI789", "DEF456", "ABC123"),
    marketValues = list(3, 2, 1),
    currency = list("USD", "USD", "USD"),
    flag = list("Invalid or missing ISIN", "Negative or missing input value", "Missing currency information")
  )
  output <- jsonlite::read_json(path = file.path(export_path_full, "invalidsecurities.json"))
  expect_equal(output, expected_output)
})
