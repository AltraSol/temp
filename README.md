
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vary

Improve readability and ease the implementation of techniques for
processing unstructured data from varying sources.

## Overview

A collection of methods intended to improve the resiliency of a data
pipeline by relying on pattern detection to define table dimensions,
filter rows, or separate attributes of flattened data. For situations
where connection points return data that has varying naming conventions,
table sizes, file types, or is completely unstructured, and additional
processing is required to ensure field consistency prior to the use of
typical data manipulation methods.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("AltraSol/vary")
```

## Usage

After installation from GitHub, you can load it with:

``` r
library(vary)
```

## Documentation

``` r
?vary::which_rows()
?vary::clean_cols_in()
?vary::clean_cols_out()
?vary::drop_na_rows()
?vary::drop_na_cols()
# ?vary::files_matching()
# ?vary::flatten_page_list()
# ?vary::get_downloads_folder()
# ?vary::load_required()
# ?vary::proper_case()
# ?vary::`%notin%`
```
