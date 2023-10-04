test_that("works as expected with global `analysis_inputs_path`", {
  with_global_analysis_inputs_path <- function (new, code) {
    if (exists("analysis_inputs_path", envir = .GlobalEnv)) {
      old <- .GlobalEnv$analysis_inputs_path
      .GlobalEnv$analysis_inputs_path <- new
      on.exit(.GlobalEnv$analysis_inputs_path <- old)
      force(code)
    } else {
      .GlobalEnv$analysis_inputs_path <- new
      on.exit(rm(analysis_inputs_path, envir = .GlobalEnv))
      force(code)
    }
  }

  withr::local_file(list(
    "entity_info.sqlite" = writeLines("foo", "entity_info.sqlite"),
    "entity_info.rds" = saveRDS("foo", "entity_info.rds")
  ))

  expect_no_error(
    with_global_analysis_inputs_path(".", get_entity_info())
  )

  expect_equal(
    with_global_analysis_inputs_path(".", get_entity_info()),
    "./entity_info.sqlite",
    ignore_attr = TRUE
  )

  withr::deferred_run()

  withr::local_file(list(
    "entity_info.rds" = saveRDS("foo", "entity_info.rds")
  ))

  expect_no_error(
    with_global_analysis_inputs_path(".", get_entity_info())
  )

  expect_equal(
    with_global_analysis_inputs_path(".", get_entity_info()),
    "foo",
    ignore_attr = TRUE
  )

  withr::deferred_run()

  expect_error(
    with_global_analysis_inputs_path(".", suppressWarnings(get_entity_info()))
  )
})
