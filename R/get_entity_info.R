#' Loads entity info so that it's ready to use
#'
#' Loads entity info from the specified path so that it's ready to use, either
#' by loading the data into memory from an RDS file, or returning a path to an
#' SQLite file with the class "db_path".
#'
#' @param dir A string containing the path to the directory where the entity
#'   info files should be found, typically the value of the
#'   `analysis_inputs_path` parameter
#'
#' @return A data frame containing the entity info, or a path with the class "db_path", either of which can be used as input to `left_join_entity_info()`
#'
#' @export

get_entity_info <- function(dir = .GlobalEnv$analysis_inputs_path) {
  sqlite_path <- file.path(dir, "entity_info.sqlite")
  if (file.exists(sqlite_path)) {
    class(sqlite_path) <- c("db_path", "character")
    return(sqlite_path)
  } else {
    entity_info <- readr::read_rds(file.path(dir, "entity_info.rds"))
    return(entity_info)
  }
}
