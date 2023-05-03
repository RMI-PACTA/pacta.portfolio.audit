calculate_value_usd_with_fin_data <- function(portfolio) {
  # check correct inputs
  necessary_columns <- c("currency", "unit_share_price")

  ### TEST
  if (!any(necessary_columns %in% colnames(portfolio))) {
    stop("Portfolio not structured correctly")
  }


  # add missing currency for number of shares
  portfolio <- portfolio %>%
    mutate(
      currency = if_else(!is.na(.data$number_of_shares), "USD", .data$currency)
    )

  # calculates the value_usd where number of shares are given
  portfolio <- portfolio %>%
    mutate(
      value_usd = if_else(
        .data$asset_type %in% c("Equity", "Funds") & is.na(.data$value_usd),
        .data$number_of_shares * .data$unit_share_price,
        .data$value_usd
      )
    )

  portfolio
}
