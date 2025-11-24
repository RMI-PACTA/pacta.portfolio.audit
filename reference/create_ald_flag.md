# Add columns to flag existence of data in ABCD for each holding

Adds columns to a portfolio data frame flagging the existence of data
related to each holding in the ABCD data. It will add the
`has_asset_level_data`, `sectors_with_assets`, and
`has_ald_in_fin_sector` columns.

## Usage

``` r
create_ald_flag(portfolio, comp_fin_data, debt_fin_data)
```

## Arguments

- portfolio:

  A data frame containing portfolio data

- comp_fin_data:

  A data frame containing company financial data

- debt_fin_data:

  A data frame containing debt financial data

## Value

A data frame similar to the input portfolion data frame with three added
columns `has_asset_level_data`, `sectors_with_assets`, and
`has_ald_in_fin_sector`
