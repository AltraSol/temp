
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vary <a href='https://github.com/ulchc/vary'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/ulchc/vary/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ulchc/vary/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

Methods to automate the loading of semi-structured data (ex. user
modified files, OCR output) which are reliable enough to form a process
around, but vary too much to immediately work with using typical data
manipulation packages.

Streamlines a few string methods to correct naming convention
differences with fuzzy matching and collapse unstructured text into a
tibble by any given break-point string. Also adds utilities to drop
entries based on NA thresholds and load files without specifying local
paths,

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

Using fuzzy_rename() when it is known that the underlying data between
two sources is equivalent

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
#> `ID #` -> `ID`
#> `Barcode` -> `Code`
#> `Product\nName` -> `Name`
#> `Day of \n the week` -> `Day`
#> `Month (MMM) ` -> `Month`
#> `Amount $` -> `Amount`
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
#> `ID #` -> `ID`
#> `Barcode` -> `Code`
#> `Product\nName` -> `Name`
#> `Day of \n the week` -> `Day`
#> `Month (MMM) ` -> `Month`
#> `Amount $` -> `Amount`
#> # A tibble: 2 × 6
#>   ID    Code  Name     Day      Month Amount
#>   <chr> <chr> <chr>    <chr>    <chr> <chr> 
#> 1 5.1.1 223   Notebook Saturday MAY   20.00 
#> 2 5.1.0 222   Book     Friday   APR   19.00
```

Use fuzzy_match() to categorize and handle spelling mistakes from OCR
text

``` r
colors_list
#> [1] "Red"    "Blue"   "Green"  "Yellow" "Violet" "Purple" "Orange"
```

``` r
color_phrases
#> [1] "The sunrise was 'yellovv'"   "There were 'purp/e' flowers"
#> [3] "The fruit was 'orang e'"
```

``` r
colors_mentioned <- fuzzy_match(color_phrases, colors_list)
#> > Fuzzy Matches
#> `The fruit was 'orang e'` -> `Orange`
#> `The sunrise was 'yellovv'` -> `Yellow`
#> `There were 'purp/e' flowers` -> `Purple`

# A message will indicate when there is a large string distance between fuzzy matches
```

``` r
writeLines(paste0("The colors mentioned were: ", paste0(colors_mentioned, collapse = ", ")))
#> The colors mentioned were: Yellow, Purple, Orange
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
?flatten_pages()
?page_search()
?drop_na_rows()
?drop_na_cols()

# Locate Files
?get_downloads_folder()
?get_desktop_folder()
?files_matching()

# Other (possible future relocation)
?`%notin%`
```
