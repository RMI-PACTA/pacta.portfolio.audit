check_missing_cols <- function(portfolio, ...) {
  required_input_cols <- c("holding_id", "market_value", "currency", "isin", "number_of_shares")

  if (!"number_of_shares" %in% colnames(portfolio)) {
    portfolio$number_of_shares <- NA_real_
  }


  missing_columns <- setdiff(required_input_cols, colnames(portfolio))

  if (length(missing_columns) > 0) {
    write_log(
      msg = paste0("The input file is missing the following data columns: ", missing_columns),
      file_path = .GlobalEnv$log_path
    )
    stop(paste0("The input file is missing the following data columns: ", missing_columns))
  }

  portfolio <- as_tibble(portfolio)

  portfolio
}
