#' Merge entity info with portfolio data
#'
#' Merges entity info with portfolio data, automatically adapting to whether the
#' entity info is a data frame in memory or a path to an SQLite database
#' containing the entity info.
#'
#' @param data A data frame containing the portfolio data
#' @param entity_info A data frame or a path to a SQLite database containing the
#'   entity info
#' @param by A length on character vector specifying the column by which to
#'   merge the datasets. Typically, and by default, "factset_entity_id"
#'
#' @return A data frame containing the portfolio data with entity info merged
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
