#' Improve the look of column names prior to export
#'
#' Replaces underscores with spaces and periods with slashes;
#' optionally changes string case.
#'
#' @param column_names A character vector of column names.
#' @param case An optional argument to change the case of the
#' strings provided to \code{"upper", "lower",} or \code{"proper"}.
#'
#' @return A vector of characters.
#' @seealso [clean_cols_in()]
#' @export
#' @examples
#' column_names <- c("amount", "payment_date_mm.dd.yyyy")
#' column_names
#' clean_cols_out(column_names, "upper")
clean_cols_out <-
  function(column_names,
           case = c("upper", "lower", "proper")) {
  column_names <- gsub("_", " ", column_names)
  column_names <- gsub("[.]", "/\\", column_names)
  if (missing(case)) {
  } else if (tolower(case) == "upper") {
    column_names <- toupper(column_names)
  } else if (tolower(case) == "lower") {
    column_names <- tolower(column_names)
  } else if (tolower(case) == "proper") {
    column_names <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(column_names), perl=TRUE)
  }
  return(column_names)
}
