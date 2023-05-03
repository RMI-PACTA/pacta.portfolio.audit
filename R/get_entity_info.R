#' A short description of the function
#'
#' A longer description of the function
#'
#' @return A description of the return value
#'
#' @export

get_entity_info <- function() {
  sqlite_path <- file.path(.GlobalEnv$analysis_inputs_path, "entity_info.sqlite")
  if (file.exists(sqlite_path)) {
    class(sqlite_path) <- c("db_path", "character")
    return(sqlite_path)
  } else {
    entity_info <- readr::read_rds(file.path(.GlobalEnv$analysis_inputs_path, "entity_info.rds"))
    return(entity_info)
  }
}
