#' Calculate the financed emissions of a portfolio, by sector and asset type
#'
#' This functions takes as input a total_portfolio object, and calculates the
#' financed emissions associated to that portfolio, by sector and asset type. If
#' no real emissions data exist for an entity, a sectoral average is used.
#'
#'
#' @param data A dataframe, like the total_portfolio object in
#'   web_tool_script_1.
#' @param entity_info A dataframe, like the `entity_info` output of
#'   `pacta.data.preparation`.
#' @param entity_emission_intensities A dataframe, like the
#'   `entity_emission_intensities` output of `pacta.data.preparation`.
#' @param average_sector_emission_intensities A dataframe, like the
#'   `average_sector_emission_intensities` output of `pacta.data.preparation`.
#'
#' @return A summarized dataset, indicating the portfolios financed emissions,
#'   per sector and asset type.
#'
#' @export

calculate_portfolio_financed_emissions <- function(data,
                                                   entity_info,
                                                   entity_emission_intensities,
                                                   average_sector_emission_intensities) {
  data <- data %>%
    select(
      "financial_sector",
      "factset_entity_id",
      "asset_type",
      "value_usd",
    ) %>%
    filter(.data$asset_type %in% c("Equity", "Bonds")) %>%
    left_join_entity_info(entity_info) %>%
    group_by(
      .data$financial_sector,
      .data$factset_entity_id,
      .data$asset_type,
      .data$bics_sector_code,
      .data$bics_sector
    ) %>%
    dplyr::summarise(
      value_usd = sum(.data$value_usd, na.rm = TRUE),
      .groups = "drop"
    )

  data <- data %>%
    left_join(entity_emission_intensities, by = "factset_entity_id")

  data <- data %>%
    left_join(
      average_sector_emission_intensities,
      by = c("bics_sector_code" = "sector_code"),
      suffix = c("", "_avg")
    )

  # use average value if no entity level data
  data <- data %>%
    mutate(
      emission_intensity_per_mkt_val = if_else(
        is.na(.data$emission_intensity_per_mkt_val),
        .data$emission_intensity_per_mkt_val_avg,
        .data$emission_intensity_per_mkt_val
      ),
      emission_intensity_per_debt = if_else(
        is.na(.data$emission_intensity_per_debt),
        .data$emission_intensity_per_debt_avg,
        .data$emission_intensity_per_debt
      )
    ) %>%
    select(!dplyr::ends_with("_avg"))

  # pick value based on asset type
  data <- data %>%
    mutate(
      emission_intensity = case_when(
        .data$asset_type == "Equity" ~ .data$emission_intensity_per_mkt_val,
        .data$asset_type == "Bonds" ~ .data$emission_intensity_per_debt
      )
    ) %>%
    select(!dplyr::ends_with("_mkt_val")) %>%
    select(!dplyr::ends_with("_debt"))

  data <- data %>%
    mutate(
      weighted_sector_emissions = .data$value_usd * .data$emission_intensity
    ) %>%
    mutate(
      sector = if_else(
        .data$financial_sector != "Other",
        .data$financial_sector,
        .data$bics_sector
      ),
      sector = if_else(
        is.na(.data$sector),
        "Other",
        .data$sector
      )
    ) %>%
    group_by(
      .data$asset_type,
      .data$sector
    ) %>%
    dplyr::summarise(
      weighted_sector_emissions = sum(
        .data$weighted_sector_emissions,
        na.rm = TRUE
      ),
      .groups = "drop"
    )

  return(data)
}
