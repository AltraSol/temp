#' Drop NA columns
#'
#' Returns a tibble or data frame without columns containing only NA values. If
#' `percent_incomplete` is supplied, any column which has greater than or equal to
#' the percentage of NA values will be dropped.
#'
#' @param df A data frame or tibble.
#' @param percent_incomplete A numeric value.
#' @return A data frame or tibble.
#' @export
#' @seealso [drop_na_rows()]
#' @examples
#' sample_data <-
#'   tibble(
#'     head(iris, 10),
#'     NA_100p = rep(NA, 10),
#'     NA_90p = c(1, rep(NA, 9))
#'   )
#'
#' sample_data
#'
#' drop_na_cols(sample_data)
#' drop_na_cols(sample_data, percent_incomplete = 90)
drop_na_cols <- function(df, percent_incomplete = 100) {
  return(df[, (1 - colSums(is.na(df))/nrow(df))*100 > (100 - percent_incomplete)])
}
