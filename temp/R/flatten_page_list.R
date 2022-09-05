flatten_page_lines <- function(page_list, rm_empty_str = TRUE) {
  split_by_newline <- str_split(page_list, "\n")
  unify_multi_list <- list(unlist(split_by_newline))
  list_to_df <- map(unify_multi_list, as_tibble)[[1]]
  list_to_df$value <- str_squish(list_to_df$value)
  if (rm_empty_str == TRUE) {
    list_to_df <- filter(list_to_df, list_to_df$value != "")
  }
  return(list_to_df)
}
