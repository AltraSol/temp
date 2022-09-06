#' Drop NA columns
#'
#' Returns a data frame without columns containing only NA values.
#'
#' @param df A data frame or tibble.
#' @return A data frame or tibble.
#' @export
#' @seealso [drop_na_rows()]
#' @examples
#' sample_data <- data.frame(head(iris, 5), NA_col = rep(NA, 5))
#' sample_data
#'
#' drop_na_cols(sample_data)
drop_na_cols <- function(df) {
  return(df[ ,colSums(is.na(df)) < nrow(df)])
}
