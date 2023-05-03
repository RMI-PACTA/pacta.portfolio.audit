calculate_number_of_shares <- function(portfolio) {
  portfolio %>%
    mutate(
      number_of_shares = ifelse(
        is.na(.data$number_of_shares) & .data$asset_type == "Equity",
        .data$value_usd / .data$unit_share_price,
        .data$number_of_shares
      )
    )
}
