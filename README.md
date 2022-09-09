
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

Use fuzzy_rename() when it is known that the underlying data between two
sources is equivalent

``` r
# The attributes of data and messy_data are the same, but naming conventions between the sources differ
```

``` r
data
#> # A tibble: 1 × 6
#>   ID    Code  Name  Day    Month Amount
#>   <chr> <chr> <chr> <chr>  <chr> <chr> 
#> 1 5.1.0 222   Book  Friday APR   19.00
messy_data
#> # A tibble: 1 × 6
#>   `Amount $` `Month (MMM) ` `Day of \n the week` `Product\nName` Barcode `ID #`
#>   <chr>      <chr>          <chr>                <chr>           <chr>   <chr> 
#> 1 20.00      MAY            Saturday             Notebook        223     5.1.1
```

``` r
names(data) %in% names(messy_data)
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE

# No names are compatible between sources
```

``` r
names(data) %in% names(fuzzy_rename(messy_data, names(data)))
#> > Fuzzy Matches
#> `Amount $` -> `Amount`
#> `Month (MMM) ` -> `Month`
#> `Product\nName` -> `Name`
#> `Day of \n the week` -> `Day`
#> `Barcode` -> `Code`
#> `ID #` -> `ID`
#> [1] TRUE TRUE TRUE TRUE TRUE TRUE

# fuzzy_rename() will match names and print out the changes
```

Automatically match, reorder, and combine without making manual
adjustments

``` r
messy_data %>%
  fuzzy_rename(data) %>%
  select(names(data)) %>%
  rbind(data)
#> > Fuzzy Matches
#> `Amount $` -> `Amount`
#> `Month (MMM) ` -> `Month`
#> `Product\nName` -> `Name`
#> `Day of \n the week` -> `Day`
#> `Barcode` -> `Code`
#> `ID #` -> `ID`
#> # A tibble: 2 × 6
#>   ID    Code  Name     Day      Month Amount
#>   <chr> <chr> <chr>    <chr>    <chr> <chr> 
#> 1 5.1.1 223   Notebook Saturday MAY   20.00 
#> 2 5.1.0 222   Book     Friday   APR   19.00
```

Use fuzzy_match() to detect similarities between different sized
character vectors

``` r
colors_list
#> [1] "Red"    "Blue"   "Green"  "Yellow" "Violet" "Purple" "Orange"
```

``` r
color_phrases
#> [1] "The sunrise was yellow"    "There were purple flowers"
#> [3] "The water was blue"
```

``` r
colors_mentioned <- fuzzy_match(color_phrases, colors_list)
#> > Fuzzy Matches
#> `The sunrise was yellow` -> `Yellow`
#> `There were purple flowers` -> `Purple`
#> `The water was blue` -> `Blue`
```

``` r
writeLines(paste0("The colors mentioned were: ", paste0(colors_mentioned, collapse = ", ")))
#> The colors mentioned were: Yellow, Purple, Blue
```

Use which_rows() to filter data with mismatched columns

``` r
# Mismatched columns: country < -- > type
```

``` r
mismatched
#> # A tibble: 12 × 4
#>   country      year type           count
#>   <chr>       <int> <chr>          <int>
#> 1 cases        1999 Afghanistan      745
#> 2 population   1999 Afghanistan 19987071
#> 3 Afghanistan  2000 cases           2666
#> 4 population   2000 Afghanistan 20595360
#> 5 Brazil       1999 cases          37737
#> # … with 7 more rows
```

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
# Using which_rows() is a non-verbose option to filter data prior to resolving mismatched attributes
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

``` r
# filter would not work under these conditions and would only return 2/3 of the rows 
```

``` r
mismatched %>% filter(type == "cases" & year == 2000)
#> # A tibble: 2 × 4
#>   country      year type   count
#>   <chr>       <int> <chr>  <int>
#> 1 Afghanistan  2000 cases   2666
#> 2 China        2000 cases 213766
```

## R Documentation

##### Use ?vary to view a linked list of all functions

``` r
# Structure Data
?which_rows()
?fuzzy_match()
?fuzzy_rename()
?flatten_page_list()
?drop_na_rows()
?drop_na_cols()

# Locate Files
?get_downloads_folder()
?files_matching()

# Other (possible future relocation)
?clean_cols_in()
?clean_cols_out()
?`%notin%`
```
