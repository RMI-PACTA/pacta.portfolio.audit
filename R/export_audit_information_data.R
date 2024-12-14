#' Export audit data for Transition Monitor website
#'
#' Exports three audit files for the Transition Monitor website, allowing the
#' website GUI to report to the user details about the audit process result.
#'
#' @param audit_file_ A data frame containing the audit data
#' @param portfolio_total_ A data frame containing the processed portfolio data
#' @param folder_path A length one character vector specifying the path where
#'   the exported audit files should be saved
#' @param project_name_ An optional length one character vector specifying a
#'   project name to prepend to the filenames. Default is `NA` which has no
#'   effect.
#'
#' @return Returns `NULL` invisibly as it is called only for its side effect of
#'   saving files
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
