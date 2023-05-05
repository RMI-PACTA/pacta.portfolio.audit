#' A short description of the function
#'
#' A longer description of the function
#'
#' @param portfolio_name_ref_all A description of the argument
#'
#' @return A description of the return value
#'
#' @export

get_input_files <- function(portfolio_name_ref_all) {
  portfolio <- tibble()

  input_path <- file.path(.GlobalEnv$project_location, "20_Raw_Inputs")

  # check that the provided reference names match to the input files

  input_files <- list.files(path = input_path, full.names = FALSE)
  input_names <- tools::file_path_sans_ext(input_files)
  portfolio_files <- grep(
    portfolio_name_ref_all,
    input_files,
    value = TRUE,
    fixed = TRUE
  )
  input_file_type <- unique(tools::file_ext(portfolio_files))

  if (!input_file_type %in% c("csv", "xlsx", "txt")) {
    write_log(
      msg = "Input file format not supported. Must be .csv, .xlsx or .txt",
      file_path = .GlobalEnv$log_path
    )
    stop("Input file format not supported. Must be .csv, .xlsx or .txt")
  }

  if (!all(portfolio_name_ref_all %in% input_names)) {
    write_log(
      msg = "Difference in input files and input argument portfolio names.",
      file_path = .GlobalEnv$log_path
    )
    stop("Difference in input files and input argument portfolio names.")
  }

  if (any(!portfolio_name_ref_all %in% input_names)) {
    write_log(
      msg = "Missing input argument",
      file_path = .GlobalEnv$log_path
    )
    stop("Missing input argument")
  }

  portfolio_file_names <- list.files(file.path(.GlobalEnv$project_location, "10_Parameter_File"))
  portfolio_file_names <- portfolio_file_names[grepl("_PortfolioParameters.yml", portfolio_file_names)]
  portfolio_file_names <- gsub("_PortfolioParameters.yml", "", portfolio_file_names)

  if (!all(portfolio_name_ref_all %in% portfolio_file_names)) {
    write_log(
      msg = "Difference in parameter files and input argument portfolio names.",
      file_path = .GlobalEnv$log_path
    )
    stop("Difference in parameter files and input argument portfolio names.")
  }
  if (any(!portfolio_name_ref_all %in% portfolio_file_names)) {
    write_log(
      msg = "Missing portfolio parameter file",
      file_path = .GlobalEnv$log_path
    )
    stop("Missing portfolio parameter file")
  }

  input_file_path <- path(input_path, paste0(portfolio_name_ref_all, ".csv"))

  portfolio <- pacta.portfolio.import::read_portfolio_csv(input_file_path)
  portfolio <- portfolio %>%
    select(-dplyr::any_of(c("investor_name", "portfolio_name")))

  has_proper_names <-
    function(data) {
      proper_names <- c("isin", "market_value", "currency")
      all(proper_names %in% names(data))
    }

  if (is.null("portfolio") || !inherits(portfolio, "data.frame") || nrow(portfolio) == 0 || !has_proper_names(portfolio)) {
    log_user_errors(
      error_name = "Portfolio CSV was malformed and could not be properly imported",
      suggested_action = "Try uploading a new CSV following the directions found here: https://platform.transitionmonitor.com/pacta2020/instructions",
      description = "Portfolio CSVs must be in a particular format for PACTA to import it correctly. Some common problems are:\n- different column names than those specified in the instructions\n- different number format than '1,234,567.89'\n- file encoding different than ASCII or UTF-8\n- inconsistent columns per row",
      immediate = TRUE
    )
  }

  portfolio <- clean_portfolio_col_types(portfolio)

  return(portfolio)
}
