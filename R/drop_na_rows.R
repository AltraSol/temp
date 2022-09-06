#' Drop NA rows
#'
#' Returns a data frame without rows containing only NA values.
#'
#' @return A data frame or tibble.
#' @export
#' @seealso [drop_na_cols()]
#' @examples
#' sample_data <- rbind(head(iris, 5), rep(NA, 5))
#' sample_data
#'
#' drop_na_rows(sample_data)
drop_na_rows <- function(df) {
  return(df[rowSums(is.na(df)) < ncol(df), ])
}
