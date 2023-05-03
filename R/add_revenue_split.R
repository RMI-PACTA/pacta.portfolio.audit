#' A short description of the function
#'
#' A longer description of the function
#'
#' @param has_revenue A description of the argument
#' @param portfolio A description of the argument
#' @param revenue_data A description of the argument
#'
#' @return A description of the return value
#'
#' @export

add_revenue_split <- function(has_revenue, portfolio, revenue_data) {
  if (has_revenue) {
    revenue_data_min <- revenue_data %>%
      filter(!is.na(.data$company_id)) %>%
      select(
        -"company_name",
        -"equity_ticker",
        -"corporate_bond_ticker",
        -"bloomberg_id"
      )

    initial_portfolio_value <- sum(portfolio$value_usd, na.rm = TRUE)

    port_rev <- left_join(portfolio, revenue_data_min, by = "company_id", all.x = TRUE)


    # Fill in gaps where possible
    port_rev <- port_rev %>%
      mutate(
        has_revenue_data = if_else(
          is.na(.data$has_revenue_data),
          FALSE,
          .data$has_revenue_data
        ),
        tot_rev = if_else(is.na(.data$tot_rev), 1, .data$tot_rev),
        revenue_sector = if_else(
          is.na(.data$revenue_sector),
          "Other",
          .data$revenue_sector
        ),
        value_usd = .data$value_usd * .data$tot_rev
      ) %>%
      rename(financial_sector = .data$revenue_sector)

    if (sum(port_rev$value_usd, na.rm = TRUE) != initial_portfolio_value) {
      stop("Revenue data causing duplications")
    }
  } else {
    port_rev <- portfolio %>%
      mutate(
        has_revenue_data = FALSE,
        financial_sector = .data$security_mapped_sector
      )
  }

  return(port_rev)
}
