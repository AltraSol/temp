
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vary <a href='https://github.com/ulchc/vary'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/ulchc/vary/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ulchc/vary/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

Methods to reliably structure data when the source format or load point
is expected to vary over time; or when inputs lack structure completely
and are not immediately compatible with typical data manipulation
packages. For situations where connection points are pdfs or user-edited
Excel sheets, and table dimensions and naming conventions need to be
dynamically set using pattern recognition.

## Motivation

To enhance code readability and increase the resilience of data
pipelines between uncommon sources and standardized reports. In keeping
with the report oriented end result, a few methods included in this
package are aimed at preparing data for export.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("ulchc/vary")
```

## Usage

After installation from GitHub, you can load it with:

``` r
library(vary)
```

    #> An example of data with mismatched columns: 'country' <-> 'type'
    #> # A tibble: 12 × 4
    #>   country      year type           count
    #>   <chr>       <int> <chr>          <int>
    #> 1 cases        1999 Afghanistan      745
    #> 2 population   1999 Afghanistan 19987071
    #> 3 Afghanistan  2000 cases           2666
    #> 4 population   2000 Afghanistan 20595360
    #> 5 Brazil       1999 cases          37737
    #> # … with 7 more rows

``` r
row_index <-
  which_rows(
    mismatched,
    contain_strings = c("CASES", "2000"),
    all_strings = TRUE,
    case_sensitive = FALSE,
    flatten = TRUE
  )
```

``` r
mismatched[row_index, ]
#> # A tibble: 3 × 4
#>   country      year type    count
#>   <chr>       <int> <chr>   <int>
#> 1 Afghanistan  2000 cases    2666
#> 2 cases        2000 Brazil  80488
#> 3 China        2000 cases  213766
```

Using row_index, 3 rows returned for cases in 2000

``` r
mismatched %>% filter(type == "cases" & year == 2000)
#> # A tibble: 2 × 4
#>   country      year type   count
#>   <chr>       <int> <chr>  <int>
#> 1 Afghanistan  2000 cases   2666
#> 2 China        2000 cases 213766
```

Using filter, 2 rows returned & 1 missed due to column misalignment

## R Documentation

##### Use ?vary to view a linked list of all functions

Structure Data

``` r
?which_rows()
?flatten_page_list()
?drop_na_rows()
?drop_na_cols()
```

Locate Files

``` r
?get_downloads_folder()
?files_matching()
```

Other (possible future relocation)

``` r
?clean_cols_in()
?clean_cols_out()
?`%notin%`
```
