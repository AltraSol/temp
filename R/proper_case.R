proper_case <- function(vec) {
  proper_vec <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(vec), perl=TRUE)
  return(proper_vec)
}
