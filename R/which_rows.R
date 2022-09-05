#' Return matching row indices
#'
#' Replaces underscores with spaces and periods with slashes;
#' optionally changes string case.
#'
#' @return An integer vector or list of integer vectors
#' @export
#' @examples
#' column_names <- c("amount", "payment_date_mm.dd.yyyy")
#' which_rows(column_names, "upper")
which_rows <-
  function(df,
           contain_strings = NULL,
           scan_cols = 1:ncol(df),
           all_strings = TRUE,
           case_sensitive = TRUE,
           lack_na = TRUE,
           flatten = TRUE) {
    scan_df <- df[, scan_cols]
    string_rows <-
      scan_df %>%
      unite("string_rows", names(scan_df), sep = " ", na.rm = T) %>%
      unlist()
    if (case_sensitive == FALSE & is.null(contain_strings) == FALSE) {
      contain_strings <- tolower(contain_strings)
      string_rows <- tolower(string_rows)
    }
    if (is.null(contain_strings) == FALSE) {
      contains_index <- map(.x = contain_strings, ~ str_which(string_rows, .x))
      names(contains_index) <- paste0("contains string: '", contain_strings, "'")
    } else {
      contains_index <- list(1:nrow(scan_df))
    }
    if (lack_na == T) {
      not_na <- which(rowSums(is.na(scan_df)) == 0)
      keep_indices <- map(.x = contains_index, ~ .x %in% not_na)
      contains_index <- map2(.x = contains_index, .y = keep_indices, ~ .x[.y])
    }
    if (length(contain_strings) == 1 | missing(contain_strings) == T) {
      if (flatten == TRUE) contains_index <- flatten_int(contains_index)
      return(contains_index)
    }
    if (all_strings == T) {
      flatten_index <- flatten_int(contains_index)
      all_strings_occur <-
        tibble(index = flatten_index) %>%
        group_by(index) %>%
        summarise(occurs = n()) %>%
        filter(occurs == length(contain_strings))
      contains_index <- list(all_strings_occur$index)
      names(contains_index) <- paste0("contains all strings: c('", paste0(contain_strings, collapse = "', '"), "')")
    }
    if (flatten == TRUE) contains_index <- sort(unique(flatten_int(contains_index)))
    return(contains_index)
  }
