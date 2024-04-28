test_that("", {
  portfolio_total_ <- data.frame(
    asset_type = c("Equity", "Bonds"),
    value_usd = 1:2,
    has_valid_input = TRUE
  )
  export_path_full <- withr::local_tempdir()

  export_audit_textvar_json(portfolio_total_, file.path(export_path_full, "coveragetextvar.json"))

  expected_output <- list(
    total = 3,
    included = 3,
    bonds = 2,
    equity = 1
  )
  output <- jsonlite::read_json(path = file.path(export_path_full, "coveragetextvar.json"))
  expect_equal(output, expected_output)
})
