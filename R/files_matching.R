files_matching <- function(path, file_type, name_contains = NULL, ignore.case = T) {
  file_type <- gsub("[[:punct:]]", "", file_type)
  file_type <- paste0("*.", file_type, "$")
  name <-
    list.files(
      path = path,
      pattern = file_type,
      full.names = F
    )
  path <-
    list.files(
      path = path,
      pattern = file_type,
      full.names = T
    )
  last_modified <- file.mtime(path)
  matching_df <- tibble(name, path, last_modified)
  matching_df <- matching_df %>%
    arrange(desc(last_modified))
  if (!missing(name_contains)) {
    matching_df <- matching_df %>%
      filter(
        grepl(
          name_contains,
          name,
          ignore.case
        )
      )
  }
  return(matching_df)
}
