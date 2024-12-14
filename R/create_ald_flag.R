#' Add columns to flag existence of data in ABCD for each holding
#'
#' Adds columns to a portfolio data frame flagging the existence of data related
#' to each holding in the ABCD data. It will add the `has_asset_level_data`,
#' `sectors_with_assets`, and `has_ald_in_fin_sector` columns.
#'
#' @param portfolio A data frame containing portfolio data
#' @param comp_fin_data A data frame containing company financial data
#' @param debt_fin_data A data frame containing debt financial data
#'
#' @return A data frame similar to the input portfolion data frame with three
#'   added columns `has_asset_level_data`, `sectors_with_assets`, and
#'   `has_ald_in_fin_sector`
#'
#' @export

create_ald_flag <- function(portfolio, comp_fin_data, debt_fin_data) {
  portfolio_eq <- portfolio %>%
    filter(.data$asset_type == "Equity")
  portfolio_cb <- portfolio %>%
    filter(.data$asset_type == "Bonds")
  portfolio_other <- portfolio %>%
    filter(!.data$asset_type %in% c("Equity", "Bonds"))

  portfolio_eq <- check_for_abcd(portfolio_eq, "Equity", comp_fin_data)
  portfolio_cb <- check_for_abcd(portfolio_cb, "Bonds", debt_fin_data)

  if (data_check(portfolio_other)) {
    portfolio_other <- portfolio_other %>%
      mutate(
        has_asset_level_data = NA,
        sectors_with_assets = NA,
        has_ald_in_fin_sector = NA
      )
  } else {
    portfolio_other <- portfolio_other %>%
      tibble::add_column(
        "has_asset_level_data",
        "sectors_with_assets",
        "has_ald_in_fin_sector"
      )
  }

  rbind(portfolio_eq, portfolio_cb, portfolio_other)
}
