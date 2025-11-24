# Calculate the financed emissions of a portfolio, by sector and asset type

This functions takes as input a total_portfolio object, and calculates
the financed emissions associated to that portfolio, by sector and asset
type. If no real emissions data exist for an entity, a sectoral average
is used.

## Usage

``` r
calculate_portfolio_financed_emissions(
  data,
  entity_info,
  entity_emission_intensities,
  average_sector_emission_intensities
)
```

## Arguments

- data:

  A dataframe, like the total_portfolio object in web_tool_script_1.

- entity_info:

  A dataframe, like the `entity_info` output of
  `pacta.data.preparation`.

- entity_emission_intensities:

  A dataframe, like the `entity_emission_intensities` output of
  `pacta.data.preparation`.

- average_sector_emission_intensities:

  A dataframe, like the `average_sector_emission_intensities` output of
  `pacta.data.preparation`.

## Value

A summarized dataset, indicating the portfolios financed emissions, per
sector and asset type.
