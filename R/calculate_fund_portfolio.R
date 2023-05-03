calculate_fund_portfolio <- function(fund_portfolio,
                                     fund_data,
                                     cols_portfolio_no_bbg,
                                     cols_funds) {
  if (data_check(fund_portfolio)) {
    fund_portfolio <- fund_portfolio %>% filter(
      .data$factset_fund_id %in% fund_data$factset_fund_id
    )

    # TODO: validate that it is conceptually correct for this join to accept multiple matches
    fund_portfolio <- left_join(
      fund_portfolio,
      fund_data,
      by = "factset_fund_id",
      multiple = "all"
    )

    fund_portfolio$direct_holding <- FALSE

    fund_portfolio$original_value_usd <- fund_portfolio$value_usd

    fund_portfolio$fund_holding_weight <- fund_portfolio$holding_reported_mv / fund_portfolio$fund_reported_mv

    fund_portfolio$value_usd <- fund_portfolio$fund_holding_weight * fund_portfolio$value_usd

    fund_portfolio$fund_isin <- fund_portfolio$isin

    fund_portfolio$isin <- fund_portfolio$holding_isin

    # If there is no fund breakdown available, return the "original isin data" to the original locations
    fund_portfolio <-
      fund_portfolio %>%
      mutate(
        value_usd = if_else(!.data$factset_fund_id %in% fund_data$factset_fund_id, .data$original_value_usd, .data$value_usd),
        isin = if_else(!.data$factset_fund_id %in% fund_data$factset_fund_id, .data$fund_isin, .data$isin),
        direct_holding = if_else(!.data$factset_fund_id %in% fund_data$factset_fund_id, TRUE, .data$direct_holding),
      )
  } else {
    fund_portfolio <- fund_portfolio %>%
      dplyr::bind_cols(
        data.frame(
          direct_holding = integer(0),
          fund_isin = character(0),
          original_value_usd = numeric(0)
        )
      )
  }

  fund_portfolio <- fund_portfolio %>%
    select(
      all_of(cols_portfolio_no_bbg),
      all_of(cols_funds)
    )

  fund_portfolio
}
