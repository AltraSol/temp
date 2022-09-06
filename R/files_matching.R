#' Search a directory for files
#'
#' todo
#'
#' @return An integer vectors or list of integer vectors.
#' @export
#' @examples
#' files_matching(getwd(), "pdf")
#' files_matching(getwd(), "xlsm", name_contains = "a")
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
  matching_df <- dplyr::tibble(name, path, last_modified)
  matching_df <- matching_df %>%
    dplyr::arrange(desc(last_modified))
  if (!missing(name_contains)) {
    matching_df <- matching_df %>%
      dplyr::filter(
        grepl(
          name_contains,
          name,
          ignore.case
        )
      )
  }
  return(matching_df)
}
