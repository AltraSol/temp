#' Structure text using return characters
#'
#' Converts a list of characters to a tibble where each row represents
#' a line of text. Primarily for use with [pdftools::pdf_text()] or
#' [pdftools::pdf_ocr_text()] when return character "\\n" separates data
#' in a meaningful way.
#'
#' @return A one column tibble.
#' @export
#' @examples
#' \code{ex_page1 <- paste0(stringr::fruit[1:5], collapse = "\n")}
#' \code{ex_page2 <- paste0(stringr::fruit[6:10], collapse = "\n")}
#' ex_page_list <- list(ex_page1, ex_page2)
#' ex_page_list
#'
#' flatten_page_lines(ex_page_list)
flatten_page_lines <- function(page_list, rm_empty_str = TRUE) {
  split_by_newline <- stringr::str_split(page_list, "\n")
  unify_multi_list <- list(unlist(split_by_newline))
  list_to_df <- purrr::map(unify_multi_list, dplyr::as_tibble)[[1]]
  list_to_df$value <- stringr::str_squish(list_to_df$value)
  if (rm_empty_str == TRUE) {
    list_to_df <- dplyr::filter(list_to_df, list_to_df$value != "")
  }
  return(list_to_df)
}
