#' A short description of the function
#'
#' A longer description of the function
#'
#' @param data A description of the argument
#' @param entity_info A description of the argument
#' @param by A description of the argument
#'
#' @return A description of the return value
#'
#' @export

left_join_entity_info <- function(data, entity_info, by = "factset_entity_id") {
  if (inherits(entity_info, "db_path")) {
    con <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = entity_info)
    on.exit(DBI::dbDisconnect(con), add = TRUE)

    dplyr::copy_to(
      dest = con,
      df = data,
      name = "portfolio",
      overwrite = TRUE,
      temporary = TRUE,
      indexes = list("factset_entity_id")
    )

    portfolio <- dplyr::tbl(con, "portfolio")
    entity_info <- dplyr::tbl(con, "entity_info")

    portfolio <-
      left_join(portfolio, entity_info, by = by) %>%
      dplyr::collect()


    # fix class of logical variables -------------------------------------------

    original_classes <-
      vapply(
        data,
        class,
        FUN.VALUE = character(1L),
        USE.NAMES = FALSE
      )

    if ("logical" %in% original_classes) {
      names_to_reclass <- names(data)[original_classes == "logical"]
      portfolio <-
        mutate(portfolio, dplyr::across(all_of(names_to_reclass), as.logical))
    }


    # --------------------------------------------------------------------------

    return(portfolio)
  }

  portfolio <- left_join(data, entity_info, by = by)
  return(portfolio)
}
