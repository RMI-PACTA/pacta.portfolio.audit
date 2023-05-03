check_for_abcd <- function(portfolio_subset, portfolio_type, relevant_fin_data) {
  if (data_check(portfolio_subset)) {
    initial_port_value <- sum(portfolio_subset$value_usd, na.rm = TRUE)

    if (portfolio_type == "Equity") {
      joining_id <- "isin"
    } else if (portfolio_type == "Bonds") {
      joining_id <- "credit_parent_id"
    }

    abcd_markers <- relevant_fin_data %>%
      select(
        all_of(c(
          joining_id,
          "has_asset_level_data",
          "sectors_with_assets"
        ))
      ) %>%
      distinct()

    portfolio_subset <- left_join(
      portfolio_subset,
      abcd_markers,
      by = joining_id
    )

    portfolio_subset <- portfolio_subset %>%
      dplyr::rowwise() %>%
      mutate(
        has_ald_in_fin_sector = if_else(
          grepl(.data$financial_sector, .data$sectors_with_assets),
          TRUE,
          FALSE
        )
      ) %>%
      ungroup()

    if (sum(portfolio_subset$value_usd, na.rm = TRUE) != initial_port_value) {
      stop("Merge over company id changes portfolio value")
    }
  } else {
    portfolio_subset <- portfolio_subset %>%
      tibble::add_column(
        "has_asset_level_data",
        "sectors_with_assets",
        "has_ald_in_fin_sector"
      )
  }
  return(portfolio_subset)
}
