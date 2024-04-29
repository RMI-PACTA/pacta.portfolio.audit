test_that("basic functionality works as expected", {
  data <- data.frame(
    financial_sector = "xxx",
    factset_entity_id = "xyz1223",
    asset_type = "Equity",
    value_usd = 10
  )

  entity_info <- data.frame(
    factset_entity_id = "xyz1223",
    bics_sector_code = "12ab",
    bics_sector = "efg"
  )

  entity_emission_intensities <- data.frame(
    factset_entity_id = "xyz1223",
    emission_intensity_per_mkt_val = 0.5,
    emission_intensity_per_debt = 0.5
  )

  average_sector_emission_intensities <- data.frame(
    sector_code = "456",
    emission_intensity_per_mkt_val = 0.6,
    emission_intensity_per_debt = 0.6
  )

  expected_output <- data.frame(
    asset_type = "Equity",
    sector = "xxx",
    weighted_sector_emissions = 5
  )

  output <- calculate_portfolio_financed_emissions(
    data,
    entity_info,
    entity_emission_intensities,
    average_sector_emission_intensities
  )

  expect_equal(output, expected_output, ignore_attr = TRUE)
})
