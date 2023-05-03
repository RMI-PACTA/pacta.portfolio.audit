clean_unmatched_holdings <- function(portfolio) {
  portfolio %>%
    mutate(
      asset_type = ifelse(
        is.na(.data$security_mapped_sector),
        "Unclassifiable",
        .data$asset_type
      )
    ) %>%
    mutate(
      security_mapped_sector = ifelse(
        is.na(.data$security_mapped_sector),
        "Unclassifiable",
        .data$security_mapped_sector
      )
    )
}
