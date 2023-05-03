#' A short description of the function
#'
#' A longer description of the function
#'
#' @param portfolio_total A description of the argument
#' @param ... A catch-all for deprecated variables (e.g. `grouping_variables`)
#'
#' @return A description of the return value
#'
#' @export

portfolio_summary <- function(portfolio_total, ...) {
  portfolio_total %>%
    ungroup() %>%
    group_by(
      .data$asset_type,
      .data$financial_sector,
      .data$valid_input
    ) %>%
    mutate(
      valid_value_usd = sum(.data$value_usd, na.rm = TRUE)
    ) %>%
    ungroup() %>%
    group_by(
      .data$asset_type,
      .data$valid_input
    ) %>%
    mutate(asset_value_usd = sum(.data$value_usd, na.rm = TRUE)) %>%
    ungroup() %>%
    group_by(
      .data$valid_input
    ) %>%
    mutate(portfolio_value_usd = sum(.data$value_usd, na.rm = TRUE)) %>%
    ungroup() %>%
    select(
      "asset_type",
      "financial_sector",
      "valid_input",
      "valid_value_usd",
      "asset_value_usd",
      "portfolio_value_usd"
    ) %>%
    distinct()
}
