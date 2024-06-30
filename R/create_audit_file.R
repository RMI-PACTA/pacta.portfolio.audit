#' A short description of the function
#'
#' A longer description of the function
#'
#' @param portfolio_total A description of the argument
#' @param has_revenue Logical determining if revenue data is included or not
#'
#' @return A description of the return value
#'
#' @export

create_audit_file <- function(portfolio_total, has_revenue) {
  audit_file <- portfolio_total %>%
    select(
      all_of(c(
        "holding_id",
        "isin",
        "value_usd",
        "company_name",
        "asset_type",
        "has_revenue_data",
        "valid_input",
        "direct_holding",
        "financial_sector",
        "bics_sector",
        "sectors_with_assets",
        "has_ald_in_fin_sector",
        "flag",
        ai_company_id = "ar_company_id"
      ))
    )

  if (has_revenue == FALSE) {
    audit_file <- audit_file %>% select(-"has_revenue_data")
  }

  return(audit_file)
}
