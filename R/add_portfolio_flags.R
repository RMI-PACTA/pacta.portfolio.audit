#' Adds flags columns to a portfolio data frame
#'
#' Adds flags columns to a portfolio data frame signifying if each holding has a
#' currency specified, has a valid value, has a valid ISIN, and has matching
#' financial data.
#'
#' @param portfolio A data frame containing a portfolio
#' @param currencies A data frame containing ISO 4217 currency codes and their exchange
#' rates.
#'
#' @return A data frame of the portfolio with the flags columns added
#'
#' @export

add_portfolio_flags <- function(
  portfolio,
  currencies
) {
  ### FLAGS/Exclusions

  portfolio <- check_isin_format(portfolio)
  portfolio <- check_missing_currency(portfolio, currencies)
  portfolio <- check_valid_input_value(portfolio)
  portfolio <- check_financial_data(portfolio)

  portfolio <- add_flags(portfolio)
  portfolio <- overall_validity_flag(portfolio)

  return(portfolio)
}
