#' A short description of the function
#'
#' A longer description of the function
#'
#' @param portfolio_raw A description of the argument
#' @param fin_data A description of the argument
#' @param fund_data A description of the argument
#' @param entity_info A description of the argument
#' @param currencies A description of the argument
#' @param total_fund_list A description of the argument
#' @param isin_to_fund_table A description of the argument
#'
#' @return A description of the return value
#'
#' @export

process_raw_portfolio <- function(portfolio_raw,
                                  fin_data,
                                  fund_data,
                                  entity_info,
                                  currencies,
                                  total_fund_list = NULL,
                                  isin_to_fund_table = isin_to_fund_table) {
  start_port_rows <- nrow(portfolio_raw)

  portfolio <- add_holding_id(portfolio_raw)

  portfolio <- check_missing_cols(portfolio)

  portfolio <- clean_portfolio_col_types(portfolio)

  portfolio <- convert_currencies(portfolio, currencies)

  cols_portfolio <- colnames(portfolio)

  cols_of_funds <- c("factset_fund_id", "direct_holding", "fund_isin", "original_value_usd")

  # Add financial data
  # Merges in the clean data and calculates the marketvalue and number of shares
  portfolio <- add_fin_data(portfolio, fin_data)
  portfolio <- left_join_entity_info(portfolio, entity_info)

  if (nrow(portfolio) != start_port_rows) {
    stop("Portfolio lines changing unexpectedly")
  }

  portfolio <- calculate_value_usd_with_fin_data(portfolio)

  portfolio <- calculate_number_of_shares(portfolio)

  original_value_usd <- sum(portfolio$value_usd, na.rm = TRUE)

  # correct Funds classification by comparing isin to the list of all known funds isins
  if (!is.null(total_fund_list)) {
    isin_to_fund_table <- isin_to_fund_table %>% filter(!is.na(.data$isin))
    portfolio <-
      portfolio %>%
      left_join(
        select(isin_to_fund_table, "isin", "factset_fund_id"),
        by = "isin"
      ) %>%
      mutate(
        asset_type = if_else(
          !is.na(.data$factset_fund_id),
          "Funds",
          .data$asset_type
        )
      )
  }
  # identify fund in the portfolio
  fund_portfolio <- identify_fund_portfolio(portfolio)

  if (data_check(fund_data)) {
    # Creates the fund_portfolio to match the original portfolio
    fund_portfolio <- calculate_fund_portfolio(fund_portfolio, fund_data, cols_portfolio, cols_of_funds)

    # Merges in the bbg data to the fund portfolio
    fund_portfolio <- add_fin_data(fund_portfolio, fin_data)
    fund_portfolio <- left_join_entity_info(fund_portfolio, entity_info)

    # add fund_portfolio and check that the total value is the same
    portfolio_total <- add_fund_portfolio(portfolio, fund_portfolio, cols_of_funds)
  } else {
    portfolio_total <- as_tibble(portfolio)
    portfolio_total$direct_holding <- TRUE
  }

  portfolio_total <- clean_unmatched_holdings(portfolio_total)

  if (!isTRUE(all.equal(sum(portfolio_total$value_usd, na.rm = TRUE), original_value_usd, tolerance = 1e-3))) {
    stop("Fund Portfolio introducing errors in total value")
  }


  ### TODO
  # summarise fund results
  # identify missing funds and isins
  ###

  return(portfolio_total)
}
