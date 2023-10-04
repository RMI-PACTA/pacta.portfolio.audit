# pacta.portfolio.audit (development version)

* `get_entity_info()` gains a `dir` argument allowing one to explicitly pass the `analysis_inputs_path` value rather than depending on it being available in the global environment, while the default behavior maintains backward compatibility with previous workflows (#17)

* Add vignette/article Attributing Company Activities to Financial Assets (#12)

* Calculate the number of shares for component holdings of funds when they are expanded, which results in an appropriate ownership weight being calculated (rather than always 0 as before) for equity indirectly held through a fund (#12)

# pacta.portfolio.audit 0.0.1

* Added a `NEWS.md` file to track changes to the package.
