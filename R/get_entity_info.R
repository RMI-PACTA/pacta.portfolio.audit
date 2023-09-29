#' A short description of the function
#'
#' A longer description of the function
#'
#' @param dir A string containing the path to the directory where the entity
#'   info files should be found, typically the value of the
#'   `analysis_inputs_path` parameter
#'
#' @return A description of the return value
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
