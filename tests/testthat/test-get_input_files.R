test_that("works as expected with global `project_location`", {
  with_test_env <- function(code) {
    dir.create(file.path(tempdir(), "10_Parameter_File"))
    dir.create(file.path(tempdir(), "20_Raw_Inputs"))

    port_param_yml <- "default:\n    parameters:\n        portfolio_name: TestPortfolio_Input\n        investor_name: Test\n        peer_group: bank\n        language: EN\n        project_code: PA2022CH\n        holdings_date:\n            - 2021Q4"
    writeLines(port_param_yml, file.path(tempdir(), "10_Parameter_File", "1234_PortfolioParameters.yml"))

    port_csv <- "Investor.Name,Portfolio.Name,ISIN,MarketValue,Currency\nZZZ,XXX,JP3868400007,50000,GBP"
    writeLines(port_csv, file.path(tempdir(), "20_Raw_Inputs", "1234.csv"))

    if (exists("project_location", envir = .GlobalEnv)) {
      old <- .GlobalEnv$project_location
      .GlobalEnv$project_location <- tempdir()
      on.exit({
        .GlobalEnv$project_location <- old
        unlink(file.path(tempdir(), "10_Parameter_File"), recursive = TRUE)
        unlink(file.path(tempdir(), "20_Raw_Inputs"), recursive = TRUE)
      })
    } else {
      .GlobalEnv$project_location <- tempdir()
      on.exit({
        rm(project_location, envir = .GlobalEnv)
        unlink(file.path(tempdir(), "10_Parameter_File"), recursive = TRUE)
        unlink(file.path(tempdir(), "20_Raw_Inputs"), recursive = TRUE)
      })
    }

    force(code)
  }

  expect_no_error(
    with_test_env(get_input_files(portfolio_name_ref_all = "1234"))
  )

  expect_equal(
    with_test_env(get_input_files(portfolio_name_ref_all = "1234")),
    tibble::tribble(
      ~isin, ~market_value, ~currency,
      "JP3868400007",         50000,     "GBP"
    ),
    ignore_attr = TRUE
  )
})
