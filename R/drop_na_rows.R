drop_na_rows <- function(df) {
  return(df[rowSums(is.na(df)) < ncol(df), ])
}
