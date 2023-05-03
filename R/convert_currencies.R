convert_currencies <- function(portfolio, currencies) {
  portfolio %>%
    left_join(currencies, by = "currency") %>%
    mutate(value_usd = .data$market_value * .data$exchange_rate)
}
