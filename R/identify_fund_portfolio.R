identify_fund_portfolio <- function(portfolio) {
  filter(portfolio, .data$asset_type == "Funds", !is.na(.data$isin))
}
