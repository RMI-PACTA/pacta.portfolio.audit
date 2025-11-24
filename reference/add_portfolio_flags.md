# Adds flags columns to a portfolio data frame

Adds flags columns to a portfolio data frame signifying if each holding
has a currency specified, has a valid value, has a valid ISIN, and has
matching financial data.

## Usage

``` r
add_portfolio_flags(portfolio, currencies)
```

## Arguments

- portfolio:

  A data frame containing a portfolio

- currencies:

  A data frame containing ISO 4217 currency codes and their exchange
  rates.

## Value

A data frame of the portfolio with the flags columns added
