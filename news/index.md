# Changelog

## pacta.portfolio.audit (development version)

- [`get_input_files()`](https://rmi-pacta.github.io/pacta.portfolio.audit/reference/get_input_files.md)
  gains a `project_location` argument allowing one to explicitly pass
  the `project_location` value rather than depending on it being
  available in the global environment, while the default behavior
  maintains backward compatibility with previous workflows
  ([\#18](https://github.com/RMI-PACTA/pacta.portfolio.audit/issues/18))

- [`get_entity_info()`](https://rmi-pacta.github.io/pacta.portfolio.audit/reference/get_entity_info.md)
  gains a `dir` argument allowing one to explicitly pass the
  `analysis_inputs_path` value rather than depending on it being
  available in the global environment, while the default behavior
  maintains backward compatibility with previous workflows
  ([\#17](https://github.com/RMI-PACTA/pacta.portfolio.audit/issues/17))

- Add vignette/article Attributing Company Activities to Financial
  Assets
  ([\#12](https://github.com/RMI-PACTA/pacta.portfolio.audit/issues/12))

- Calculate the number of shares for component holdings of funds when
  they are expanded, which results in an appropriate ownership weight
  being calculated (rather than always 0 as before) for equity
  indirectly held through a fund
  ([\#12](https://github.com/RMI-PACTA/pacta.portfolio.audit/issues/12))

## pacta.portfolio.audit 0.0.1

- Added a `NEWS.md` file to track changes to the package.
