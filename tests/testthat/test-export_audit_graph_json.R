test_that("", {
  all_flags <- c(
    "Missing currency information",
    "Negative or missing input value",
    "Invalid or missing ISIN",
    "Holding not in financial database",
    "Included in analysis"
  )

  audit_file__ <- data.frame(
    isin = c("ABC123", "DEF456", "GHI789", "JKL012", "MNO345"),
    holding_id = 1:5,
    flag = all_flags
  )
  export_path_full <- withr::local_tempdir()

  export_audit_graph_json(audit_file__, paste0(export_path_full, "/coveragegraph"))

  expected_output <- list(
    key_1 = "Invalid input",
    key_2 = "No data coverage",
    key_3 = "Included in analysis"
  )
  output <- jsonlite::read_json(path = file.path(export_path_full, "coveragegraphlegend.json"))
  expect_equal(output, expected_output)

  expected_output <- list(
    key_1 = 3,
    key_2 = 1,
    key_3 = 1
  )
  output <- jsonlite::read_json(path = file.path(export_path_full, "coveragegraph.json"))
  expect_equal(output, expected_output)
})
