# Export audit data for Transition Monitor website

Exports three audit files for the Transition Monitor website, allowing
the website GUI to report to the user details about the audit process
result.

## Usage

``` r
export_audit_information_data(
  audit_file_ = .GlobalEnv$audit_file,
  portfolio_total_ = .GlobalEnv$portfolio_total,
  folder_path = .GlobalEnv$proc_input_path,
  project_name_ = NA
)
```

## Arguments

- audit_file\_:

  A data frame containing the audit data

- portfolio_total\_:

  A data frame containing the processed portfolio data

- folder_path:

  A length one character vector specifying the path where the exported
  audit files should be saved

- project_name\_:

  An optional length one character vector specifying a project name to
  prepend to the filenames. Default is `NA` which has no effect.

## Value

Returns `NULL` invisibly as it is called only for its side effect of
saving files
