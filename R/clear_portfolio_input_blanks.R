clear_portfolio_input_blanks <- function(portfolio, grouping_variables) {
  input_blanks_or_nas_exist <- any(
    portfolio[, grouping_variables] == "" |
      is.na(portfolio[, grouping_variables])
  )

  if (input_blanks_or_nas_exist) {
    print("Warning: missing grouping variables, corresponding rows removed")
    write_log(
      msg = paste(
        "Warning: some entries of the uploaded portfolio file were removed
              because of missing values in at least one of the variables",
        stringr::str_c(grouping_variables, collapse = ", "),
        "\n To ensure complete analysis, please upload a file without
                          missing values in these columns."
      ),
      file_path = .GlobalEnv$log_path
    )

    portfolio <- portfolio %>%
      dplyr::filter_at(
        grouping_variables,
        dplyr::all_vars(!is.na(.))
      )
  }

  portfolio
}
