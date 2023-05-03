check_isin_format <- function(portfolio_total) {
  mutate(portfolio_total, has_valid_isin = pacta.portfolio.import::is_valid_isin(.data$isin))
}
