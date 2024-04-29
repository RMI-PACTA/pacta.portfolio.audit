test_that("basic functionality works as expected", {
  portfolio <- data.frame(
    asset_type = c("Equity", "Bonds", "Other"),
    value_usd = 1:3,
    isin = c("abc123", "def456", "ghi789"),
    credit_parent_id = c("xyz321", "uvw654", "rst987"),
    financial_sector = c("Power", "Oil&Gas", "Automotive")
  )
  comp_fin_data <- data.frame(
    isin = c("abc123", "def456", "ghi789"),
    has_asset_level_data = c(TRUE, TRUE, TRUE),
    sectors_with_assets = c("Power", "Oil&Gas + Coal", "Automotive")
  )
  debt_fin_data <- data.frame(
    credit_parent_id = c("xyz321", "uvw654", "rst987"),
    has_asset_level_data = c(TRUE, TRUE, TRUE),
    sectors_with_assets = c("Power", "Oil&Gas + Coal", "Automotive")
  )

  expected_output <- data.frame(
    asset_type = c("Equity", "Bonds", "Other"),
    value_usd = 1:3,
    isin = c("abc123", "def456", "ghi789"),
    credit_parent_id = c("xyz321", "uvw654", "rst987"),
    financial_sector = c("Power", "Oil&Gas", "Automotive"),
    has_asset_level_data = c(TRUE, TRUE, NA),
    sectors_with_assets = c("Power", "Oil&Gas + Coal", NA),
    has_ald_in_fin_sector = c(TRUE, TRUE, NA)
  )

  output <- create_ald_flag(portfolio, comp_fin_data, debt_fin_data)
  expect_equal(output, expected_output, ignore_attr = TRUE)
})
