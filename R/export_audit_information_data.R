#' A short description of the function
#'
#' A longer description of the function
#'
#' @param audit_file_ A description of the argument
#' @param portfolio_total_ A description of the argument
#' @param folder_path A description of the argument
#' @param project_name_ A description of the argument
#'
#' @return A description of the return value
#'
#' @export

export_audit_information_data <- function(audit_file_ = .GlobalEnv$audit_file,
                                          portfolio_total_ = .GlobalEnv$portfolio_total,
                                          folder_path = .GlobalEnv$proc_input_path,
                                          project_name_ = NA) {
  # Check format
  if (isFALSE(is.character(folder_path) && length(folder_path) == 1)) {
    stop("`folder_path`` is not a string (a length one character vector).")
  }
  if (isFALSE(is.data.frame(audit_file_))) {
    stop("`audit_file_` is not a data.frame")
  }

  folder_path <- paste0(folder_path, "/")
  if (!is.na(project_name_)) {
    folder_path <- paste0(folder_path, project_name_, "_")
  }
  # function
  export_audit_graph_json(audit_file_, paste0(folder_path, "coveragegraph"))
  export_audit_invalid_data(portfolio_total_, paste0(folder_path, "invalidsecurities"))
  export_audit_textvar_json(portfolio_total_, file.path(folder_path, "coveragetextvar.json"))
}
