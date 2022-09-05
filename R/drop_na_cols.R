drop_na_cols <- function(df) {
  return(df[ ,colSums(is.na(df)) < nrow(df)])
}
